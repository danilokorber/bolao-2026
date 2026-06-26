package io.easyware.bolao.services;

import io.easyware.bolao.clients.TheOddsApiClient;
import io.easyware.bolao.dto.theoddsapi.TheOddsOdds;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.repositories.MatchRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import java.text.Normalizer;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import jakarta.transaction.Transactional;

@ApplicationScoped
@Slf4j
public class OddsService {

    @Inject
    @RestClient
    TheOddsApiClient theOddsApiClient;

    @Inject
    MatchRepository matchRepository;

    /**
     * Fetches odds for every currently-priced World Cup match in a single bulk
     * request (1 API credit) and stores the latest average h2h odds on each
     * matching, still-scheduled, future match.
     *
     * <p>Matches that are in play or already played are skipped so live odds never
     * overwrite the pre-kickoff line once bets are locked.
     */
    @Transactional
    public void updateOddsForAllMatches() {
        List<TheOddsOdds> events;
        try {
            events = theOddsApiClient.getAllOdds();
        } catch (RuntimeException exception) {
            log.error("Failed to fetch odds from The Odds API: {}", exception.getMessage(), exception);
            return;
        }

        if (events == null || events.isEmpty()) {
            log.info("The Odds API returned no priced events; nothing to update");
            return;
        }

        List<Match> matches = matchRepository.listAll();
        LocalDateTime now = LocalDateTime.now(ZoneOffset.UTC);

        int updated = 0;
        int skipped = 0;
        int unmatched = 0;

        for (TheOddsOdds event : events) {
            Match match = findMatchingMatch(event, matches);
            if (match == null) {
                unmatched++;
                logUnmatchedEvent(event, matches);
                continue;
            }

            if (match.getStatus() != MatchStatus.SCHEDULED
                    || match.getMatchDatetime() == null
                    || !match.getMatchDatetime().isAfter(now)) {
                skipped++;
                continue;
            }

            match.setHomeOdds(roundOdds(event.getAverageHome()));
            match.setAwayOdds(roundOdds(event.getAverageAway()));
            match.setDrawOdds(roundOdds(event.getAverageDraw()));
            updated++;
        }

        log.info("Odds update complete: {} event(s) received, {} updated, {} skipped (in-play/past), {} unmatched",
                events.size(), updated, skipped, unmatched);
    }

    private Double roundOdds(Double odds) {
        if (odds == null) {
            return null;
        }
        return Math.round(odds * 100.0d) / 100.0d;
    }

    private void logUnmatchedEvent(TheOddsOdds event, List<Match> matches) {
        LocalDateTime kickoff = parseUtc(event.getCommenceTime());
        List<MatchCandidate> candidates = new ArrayList<>();

        for (Match match : matches) {
            if (match == null || match.getMatchDatetime() == null) {
                continue;
            }

            Team homeTeam = match.getHomeTeam();
            Team awayTeam = match.getAwayTeam();
            if (homeTeam == null || awayTeam == null) {
                continue;
            }

            TeamMatchDetails homeMatch = describeTeamMatch(homeTeam, event.getHomeTeam());
            TeamMatchDetails awayMatch = describeTeamMatch(awayTeam, event.getAwayTeam());
            TeamMatchDetails swappedHomeMatch = describeTeamMatch(homeTeam, event.getAwayTeam());
            TeamMatchDetails swappedAwayMatch = describeTeamMatch(awayTeam, event.getHomeTeam());

            boolean sameTeams = homeMatch.matched && awayMatch.matched;
            boolean swappedTeams = swappedHomeMatch.matched && swappedAwayMatch.matched;
            long minutesDiff = kickoff == null ? Long.MAX_VALUE : Math.abs(Duration.between(kickoff, match.getMatchDatetime()).toMinutes());

            if (sameTeams || swappedTeams || homeMatch.matched || awayMatch.matched || minutesDiff <= 180) {
                String reason = sameTeams ? "same-teams" : swappedTeams ? "swapped-teams" : homeMatch.matched
                        ? "home-match" : awayMatch.matched ? "away-match" : "time-close";
                int score = (sameTeams ? 100 : 0)
                        + (swappedTeams ? 80 : 0)
                        + (homeMatch.matched ? 40 : 0)
                        + (awayMatch.matched ? 40 : 0)
                        + (minutesDiff == Long.MAX_VALUE ? 0 : Math.max(0, 180 - (int) minutesDiff));
                candidates.add(new MatchCandidate(score, String.format(
                        Locale.ROOT,
                        "%s[%s home=%s away=%s swap=%s/%s] %s vs %s @ %s (Δ%dm)",
                        match.getMatchId() != null ? match.getMatchId() : match.getId(),
                        reason,
                        homeMatch.matched ? homeMatch.source : "-",
                        awayMatch.matched ? awayMatch.source : "-",
                        swappedHomeMatch.matched ? swappedHomeMatch.source : "-",
                        swappedAwayMatch.matched ? swappedAwayMatch.source : "-",
                        homeTeam.getNameEn(),
                        awayTeam.getNameEn(),
                        match.getMatchDatetime(),
                        minutesDiff == Long.MAX_VALUE ? -1 : minutesDiff
                )));
            }
        }

        candidates.sort(Comparator.comparingInt(MatchCandidate::score).reversed()
                .thenComparing(MatchCandidate::description));
        String candidateSummary = candidates.stream()
                .limit(3)
                .map(MatchCandidate::description)
                .collect(Collectors.joining(" | "));
        log.warn(String.format(
                Locale.ROOT,
                "Unmatched odds event id=%s kickoff=%s home=%s away=%s candidates=%s",
                event.getId(),
                event.getCommenceTime(),
                event.getHomeTeam(),
                event.getAwayTeam(),
                candidateSummary.isBlank() ? "<none>" : candidateSummary
        ));
    }

    private record MatchCandidate(int score, String description) {
    }

    private TeamMatchDetails describeTeamMatch(Team team, String eventTeamName) {
        if (team == null || eventTeamName == null) {
            return TeamMatchDetails.noMatch();
        }

        String normalizedEventTeamName = normalize(eventTeamName);
        if (normalizedEventTeamName.equals(normalize(team.getNameEn()))) {
            return new TeamMatchDetails(true, "en");
        }
        if (normalizedEventTeamName.equals(normalize(team.getNameDe()))) {
            return new TeamMatchDetails(true, "de");
        }
        if (normalizedEventTeamName.equals(normalize(team.getNamePt()))) {
            return new TeamMatchDetails(true, "pt");
        }
        if (normalizedEventTeamName.equals(normalize(team.getFifaCode()))) {
            return new TeamMatchDetails(true, "fifa");
        }
        return TeamMatchDetails.noMatch();
    }

    private record TeamMatchDetails(boolean matched, String source) {
        private static TeamMatchDetails noMatch() {
            return new TeamMatchDetails(false, "none");
        }
    }

    private Match findMatchingMatch(TheOddsOdds event, List<Match> matches) {
        if (event == null) {
            return null;
        }

        LocalDateTime kickoff = parseUtc(event.getCommenceTime());
        if (kickoff == null) {
            return null;
        }

        String eventHomeTeam = normalize(event.getHomeTeam());
        String eventAwayTeam = normalize(event.getAwayTeam());

        for (Match match : matches) {
            if (match == null || match.getMatchDatetime() == null) {
                continue;
            }
            if (!kickoff.equals(match.getMatchDatetime())) {
                continue;
            }
            if (teamMatches(match.getHomeTeam(), eventHomeTeam) && teamMatches(match.getAwayTeam(), eventAwayTeam)) {
                return match;
            }
        }

        return null;
    }

    private boolean teamMatches(Team team, String eventTeamName) {
        if (team == null || eventTeamName == null) {
            return false;
        }

        return eventTeamName.equals(normalize(team.getNameEn()))
                || eventTeamName.equals(normalize(team.getNameDe()))
                || eventTeamName.equals(normalize(team.getNamePt()))
                || eventTeamName.equals(normalize(team.getFifaCode()));
    }

    private LocalDateTime parseUtc(String commenceTime) {
        if (commenceTime == null || commenceTime.isBlank()) {
            return null;
        }
        return OffsetDateTime.parse(commenceTime).atZoneSameInstant(ZoneOffset.UTC).toLocalDateTime();
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }

        String normalized = Normalizer.normalize(value, Normalizer.Form.NFKD)
                .replaceAll("\\p{M}+", "")
                .replace("&", " and ")
                .replaceAll("\\s+", " ");
        return normalized.trim().toLowerCase(Locale.ROOT);
    }
}
