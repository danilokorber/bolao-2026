package io.easyware.bolao.services;

import io.easyware.bolao.clients.TheOddsApiClient;
import io.easyware.bolao.dto.theoddsapi.TheOddsEvent;
import io.easyware.bolao.dto.theoddsapi.TheOddsOdds;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.repositories.MatchRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.jboss.resteasy.reactive.ClientWebApplicationException;

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

@ApplicationScoped
public class OddsService {

    @Inject
    @RestClient
    TheOddsApiClient theOddsApiClient;

    @Inject
    MatchRepository matchRepository;

    public void printAllEventsWithMatchingMatches() {
        List<TheOddsEvent> events = theOddsApiClient.getEvents();
        List<Match> matches = matchRepository.listAll();

        for (TheOddsEvent event : events) {
            Match match = findMatchingMatch(event, matches);
            String matchId = match != null
                    ? String.valueOf(match.getMatchId() != null ? match.getMatchId() : match.getId())
                    : "🟥";
            LocalDateTime matchTime = match != null ? match.getMatchDatetime() : parseUtc(event.getCommenceTime());

            if (match == null) {
                logUnmatchedEvent(event, matches);
            }

            TheOddsOdds odds;
            try {
                odds = theOddsApiClient.getOddsForEvent(event.getId());
            } catch (ClientWebApplicationException exception) {
                System.err.println(formatOddsFailure(matchId, matchTime, event, exception));
                continue;
            }

            String line = String.format(
                    Locale.ROOT,
                    "%s  %s %s %.2f %.2f %.2f %s",
                    matchId,
                    matchTime,
                    event.getHomeTeam(),
                    odds.getAverageHome(),
                    odds.getAvarageDraw(),
                    odds.getAverageAway(),
                    event.getAwayTeam()
            );
            System.out.println(line);
        }
    }

    private void logUnmatchedEvent(TheOddsEvent event, List<Match> matches) {
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
        System.err.println(String.format(
                Locale.ROOT,
                "Unmatched event id=%s kickoff=%s home=%s away=%s candidates=%s",
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

    private String formatOddsFailure(String matchId,
                                     LocalDateTime matchTime,
                                     TheOddsEvent event,
                                     ClientWebApplicationException exception) {
        String responseBody = readResponseBody(exception);
        return String.format(
                Locale.ROOT,
                "Odds API error for event %s [%s -> %s] match=%s time=%s status=%s body=%s",
                event.getId(),
                event.getHomeTeam(),
                event.getAwayTeam(),
                matchId,
                matchTime,
                exception.getResponse().getStatus(),
                responseBody
        );
    }

    private String readResponseBody(ClientWebApplicationException exception) {
        try {
            String body = exception.getResponse().readEntity(String.class);
            return body == null || body.isBlank() ? "<empty>" : body;
        } catch (RuntimeException readException) {
            return "<unreadable response body: " + readException.getClass().getSimpleName() + ">";
        }
    }

    private Match findMatchingMatch(TheOddsEvent event, List<Match> matches) {
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
                .replaceAll("\\p{M}+", "");
        return normalized.trim().toLowerCase(Locale.ROOT);
    }
}
