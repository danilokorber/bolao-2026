package io.easyware.bolao.services;

import io.easyware.bolao.dto.footballdata.FootballDataMatch;
import io.easyware.bolao.dto.footballdata.FootballDataResponse;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.repositories.MatchRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.Optional;

@ApplicationScoped
@Slf4j
public class FootballDataService {

    @Inject
    MatchRepository matchRepository;

    /**
     * Updates match scores from football-data.org API response
     */
    @Transactional
    public void updateMatchFromFootballData(FootballDataMatch footballDataMatch) {
        Long footballDataId = footballDataMatch.getId();
        
        Optional<Match> matchOpt = matchRepository.find("footballDataMatchId", footballDataId).firstResultOptional();
        
        if (matchOpt.isEmpty()) {
            log.warn("No match found with football_data_match_id: {}", footballDataId);
            return;
        }
        
        Match match = matchOpt.get();
        
        // Update match status
        match.setStatus(mapStatus(footballDataMatch.getStatus()));
        
        // Update scores if available
        if (footballDataMatch.getScore() != null && footballDataMatch.getScore().getFullTime() != null) {
            FootballDataMatch.Score.TimeScore fullTime = footballDataMatch.getScore().getFullTime();
            match.setHomeGoals(fullTime.getHome());
            match.setAwayGoals(fullTime.getAway());
        }
        
        matchRepository.persist(match);
        log.info("Updated match {} from football-data.org", footballDataId);
    }

    /**
     * Updates all matches from a football-data.org API response
     */
    @Transactional
    public void updateAllMatches(FootballDataResponse response) {
        log.info("Updating {} matches from football-data.org", response.getMatches().size());
        
        for (FootballDataMatch footballDataMatch : response.getMatches()) {
            try {
                updateMatchFromFootballData(footballDataMatch);
            } catch (Exception e) {
                log.error("Error updating match {}", footballDataMatch.getId(), e);
            }
        }
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
