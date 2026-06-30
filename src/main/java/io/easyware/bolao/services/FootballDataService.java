package io.easyware.bolao.services;

import io.easyware.bolao.dto.footballdata.FootballDataMatch;
import io.easyware.bolao.dto.footballdata.FootballDataResponse;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.repositories.MatchRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@ApplicationScoped
@Slf4j
public class FootballDataService {

    @Inject
    MatchRepository matchRepository;

    /**
     * Updates a single match from football-data.org API data.
     * Returns the match UUID if this update requires score recalculation, i.e.:
     * <ul>
     *   <li>The match just transitioned to FINISHED</li>
     *   <li>The match is LIVE and its score changed (goal scored)</li>
     *   <li>The match is LIVE and it just kicked off (transition from SCHEDULED)</li>
     * </ul>
     *
     * @param footballDataMatch the external API match data
     * @return the UUID of the match if scores need recalculation, empty otherwise
     */
    @Transactional
    public Optional<UUID> updateMatchFromFootballData(FootballDataMatch footballDataMatch) {
        Long footballDataId = footballDataMatch.getId();
        
        Optional<Match> matchOpt = matchRepository.find("footballDataMatchId", footballDataId).firstResultOptional();
        
        if (matchOpt.isEmpty()) {
//            log.warn("No match found with football_data_match_id: {}", footballDataId);
            return Optional.empty();
        }
        
        Match match = matchOpt.get();
        MatchStatus previousStatus = match.getStatus();
        Integer previousHomeGoals = match.getHomeGoals();
        Integer previousAwayGoals = match.getAwayGoals();
        MatchStatus newStatus = normalizeStatus(match, mapStatus(footballDataMatch.getStatus()));

        match.setStatus(newStatus);
        
        // Update scores if available. football-data.org folds the penalty shootout into
        // score.fullTime for knockout matches (e.g. a 0-0 draw decided 3-0 on penalties is
        // reported as fullTime 3-0). Keep the two separated: home/away goals hold the score
        // after extra time (fullTime minus the shootout), and the shootout result is stored
        // in its own home/away penalty columns.
        if (footballDataMatch.getScore() != null && footballDataMatch.getScore().getFullTime() != null) {
            FootballDataMatch.Score score = footballDataMatch.getScore();
            FootballDataMatch.Score.TimeScore fullTime = score.getFullTime();
            FootballDataMatch.Score.TimeScore penalties = score.getPenalties();

            if (penalties != null && penalties.getHome() != null && penalties.getAway() != null) {
                match.setHomePenalties(penalties.getHome());
                match.setAwayPenalties(penalties.getAway());
                match.setHomeGoals(subtractPenalties(fullTime.getHome(), penalties.getHome()));
                match.setAwayGoals(subtractPenalties(fullTime.getAway(), penalties.getAway()));
            } else {
                match.setHomeGoals(fullTime.getHome());
                match.setAwayGoals(fullTime.getAway());
            }
        }

        // Detect extra time / penalties from duration field
        if (footballDataMatch.getScore() != null) {
            String duration = footballDataMatch.getScore().getDuration();
            if ("EXTRA_TIME".equals(duration)) {
                match.setWentToExtraTime(true);
            } else if ("PENALTY_SHOOTOUT".equals(duration)) {
                match.setWentToExtraTime(true);
                match.setWentToPenalties(true);
            }
        }

        // Once finished, record the winner. {@code score.winner} is penalty-aware: a knockout
        // decided on penalties reports the shootout winner here (HOME_TEAM/AWAY_TEAM), not DRAW.
        // A drawn group game reports DRAW and leaves the winner null. This also drives knockout
        // bracket advancement and final → champion-bet scoring.
        if (newStatus == MatchStatus.FINISHED && footballDataMatch.getScore() != null) {
            String winner = footballDataMatch.getScore().getWinner();
            if ("HOME_TEAM".equals(winner)) {
                match.setWinner(match.getHomeTeam());
            } else if ("AWAY_TEAM".equals(winner)) {
                match.setWinner(match.getAwayTeam());
            }
        }

        matchRepository.persist(match);

        // Determine if score recalculation is needed
        boolean needsRecalc = false;

        boolean justFinished = previousStatus != MatchStatus.FINISHED && newStatus == MatchStatus.FINISHED;
        boolean justWentLive = previousStatus != MatchStatus.LIVE && newStatus == MatchStatus.LIVE;
        boolean scoreChanged = !Objects.equals(previousHomeGoals, match.getHomeGoals())
                            || !Objects.equals(previousAwayGoals, match.getAwayGoals());
        boolean isActiveMatch = newStatus == MatchStatus.LIVE || newStatus == MatchStatus.FINISHED;

        if (justFinished) {
            log.info("Match {} (football-data: {}) just FINISHED with score {}–{}",
                    match.getMatchId(), footballDataId, match.getHomeGoals(), match.getAwayGoals());
            needsRecalc = true;
        } else if (justWentLive) {
            log.info("Match {} (football-data: {}) just kicked off",
                    match.getMatchId(), footballDataId);
            needsRecalc = true;
        } else if (isActiveMatch && scoreChanged) {
            log.info("Match {} (football-data: {}) score changed to {}–{}",
                    match.getMatchId(), footballDataId, match.getHomeGoals(), match.getAwayGoals());
            needsRecalc = true;
        }

        if (needsRecalc) {
            return Optional.of(match.getId());
        }

        if (newStatus == MatchStatus.LIVE) {
            log.info("LIVE match {} (football-data: {}) — current score: {}–{} (no change)",
                    match.getMatchId(), footballDataId, match.getHomeGoals(), match.getAwayGoals());
        } else {
            log.debug("Updated match {} from football-data.org (status: {}, no score change)", footballDataId, newStatus);
        }
        return Optional.empty();
    }

    /**
     * Updates all matches from a football-data.org API response.
     * Returns the UUIDs of matches that need score recalculation — either because they
     * just finished, just went live, or had a score change while live.
     *
     * @param response the football-data.org API response
     * @return list of match UUIDs needing score recalculation
     */
    @Transactional
    public List<UUID> updateAllMatches(FootballDataResponse response) {
        log.info("Updating {} matches from football-data.org", response.getMatches().size());
        
        List<UUID> needsRecalc = new ArrayList<>();

        for (FootballDataMatch footballDataMatch : response.getMatches()) {
            try {
                updateMatchFromFootballData(footballDataMatch)
                        .ifPresent(needsRecalc::add);
            } catch (Exception e) {
                log.error("Error updating match {}", footballDataMatch.getId(), e);
            }
        }

        if (!needsRecalc.isEmpty()) {
            log.info("{} match(es) need score recalculation", needsRecalc.size());
        }

        log.info("Updated {} matches from football-data.org", response.getMatches().size());
        return needsRecalc;
    }

    /**
     * Recovers the after-extra-time score by removing the penalty shootout tally that
     * football-data.org folds into {@code score.fullTime}. Guards against missing values.
     *
     * @param fullTimeGoals the fullTime score for a side (shootout included)
     * @param penaltyGoals  the shootout score for the same side
     * @return the score after extra time, or {@code null} if {@code fullTimeGoals} is null
     */
    private static Integer subtractPenalties(Integer fullTimeGoals, Integer penaltyGoals) {
        if (fullTimeGoals == null) {
            return null;
        }
        if (penaltyGoals == null) {
            return fullTimeGoals;
        }
        return fullTimeGoals - penaltyGoals;
    }

    private io.easyware.bolao.enums.MatchStatus mapStatus(String footballDataStatus) {
        return switch (footballDataStatus) {
            case "SCHEDULED", "TIMED" -> io.easyware.bolao.enums.MatchStatus.SCHEDULED;
            case "IN_PLAY", "PAUSED" -> io.easyware.bolao.enums.MatchStatus.LIVE;
            case "FINISHED" -> io.easyware.bolao.enums.MatchStatus.FINISHED;
            case "CANCELLED", "POSTPONED" -> io.easyware.bolao.enums.MatchStatus.CANCELLED;
            default -> {
                log.warn("Unknown football-data status: {}", footballDataStatus);
                yield io.easyware.bolao.enums.MatchStatus.SCHEDULED;
            }
        };
    }

    private MatchStatus normalizeStatus(Match match, MatchStatus incomingStatus) {
        MatchStatus currentStatus = match.getStatus();

        // football-data.org can lag around kickoff, so keep terminal/active states monotonic.
        if (currentStatus == MatchStatus.FINISHED || currentStatus == MatchStatus.CANCELLED) {
            return currentStatus;
        }

        if (currentStatus == MatchStatus.LIVE) {
            return incomingStatus == MatchStatus.FINISHED ? MatchStatus.FINISHED : MatchStatus.LIVE;
        }

        if (incomingStatus == MatchStatus.SCHEDULED && hasStarted(match)) {
            return MatchStatus.LIVE;
        }

        return incomingStatus;
    }

    private boolean hasStarted(Match match) {
        if (match.getMatchDatetime() == null) {
            return false;
        }

        LocalDateTime kickoffUtc = match.getMatchDatetime();
        return !kickoffUtc.isAfter(LocalDateTime.now(ZoneOffset.UTC));
    }
}
