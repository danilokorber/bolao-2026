package io.easyware.bolao.schedules;

import io.easyware.bolao.clients.FootballDataClient;
import io.easyware.bolao.dto.footballdata.FootballDataResponse;
import io.easyware.bolao.services.FootballDataService;
import io.easyware.bolao.services.ScoreCalculationService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import io.quarkus.scheduler.Scheduled;

import java.util.List;
import java.util.UUID;

/**
 * Scheduled job that polls football-data.org for all World Cup 2026 matches
 * via the bulk endpoint ({@code /v4/competitions/2000/matches}) and triggers
 * point calculation when scores or statuses change.
 *
 * <p>Each tick fetches the full match list in a single API call, updates
 * every match in the database, and recalculates scores for any that changed.
 *
 * <p>The schedule is configured via:
 * <pre>
 *   bolao.schedules.matches.schedule  (cron expression, default: every minute)
 *   bolao.schedules.matches.enabled   (boolean, default: true)
 * </pre>
 */
@ApplicationScoped
@Slf4j
public class MatchUpdateScheduler {

    @Inject
    FootballDataService footballDataService;

    @Inject
    ScoreCalculationService scoreCalculationService;

    @Inject
    @RestClient
    FootballDataClient footballDataClient;

    @ConfigProperty(name = "bolao.schedules.matches.enabled", defaultValue = "true")
    boolean enabled;

    /**
     * Polls all World Cup matches from football-data.org and recalculates
     * scores for any matches whose status or score changed.
     */
    @Scheduled(cron = "${bolao.schedules.matches.schedule:0 0/1 * * * ?}",
               identity = "match-update-scheduler")
    void updateMatchesAndCalculateScores() {
        if (!enabled) {
            log.info("Match update scheduler is disabled");
            return;
        }

        try {
            FootballDataResponse response = footballDataClient.getWorldCupMatches();
            log.info("Fetched {} matches from football-data.org", response.getMatches().size());

            List<UUID> changedMatchIds = footballDataService.updateAllMatches(response);

            if (!changedMatchIds.isEmpty()) {
                log.info("{} match(es) changed — recalculating scores", changedMatchIds.size());
                scoreCalculationService.calculatePointsForMatches(changedMatchIds);
            }
        } catch (Exception e) {
            log.error("Error polling football-data.org", e);
        }
    }

    /**
     * Manually triggers score calculation for specific matches.
     *
     * @param matchIds the UUIDs of matches to recalculate
     * @return number of bets updated
     */
    public int triggerScoreCalculation(List<UUID> matchIds) {
        return scoreCalculationService.calculatePointsForMatches(matchIds);
    }
}
