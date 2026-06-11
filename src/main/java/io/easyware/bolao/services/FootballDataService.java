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
        MatchStatus newStatus = mapStatus(footballDataMatch.getStatus());

        match.setStatus(newStatus);
        
        // Update scores if available
        if (footballDataMatch.getScore() != null && footballDataMatch.getScore().getFullTime() != null) {
            FootballDataMatch.Score.TimeScore fullTime = footballDataMatch.getScore().getFullTime();
            match.setHomeGoals(fullTime.getHome());
            match.setAwayGoals(fullTime.getAway());
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
}
