package io.easyware.bolao.schedules;

import io.easyware.bolao.services.FootballDataService;
import io.easyware.bolao.services.ScoreCalculationService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import io.quarkus.scheduler.Scheduled;

import java.util.List;
import java.util.UUID;

/**
 * Scheduled job that polls the football-data.org API for match updates
 * and triggers point calculation for matches with score changes.
 *
 * <p>Points are evaluated in <strong>real time</strong>: every minute the scheduler checks
 * for score updates. When a LIVE match has a new goal or a match just kicks off or finishes,
 * only the bets for those specific matches are recalculated.
 *
 * <p>The schedule is configured via:
 * <pre>
 *   bolao.schedules.matches.schedule  (cron expression, default: every minute)
 *   bolao.schedules.matches.enabled   (boolean, default: true)
 * </pre>
 *
 * <h3>Flow</h3>
 * <ol>
 *   <li>Poll football-data.org for current match data</li>
 *   <li>{@link FootballDataService} updates match records and returns IDs of matches with score changes</li>
 *   <li>{@link ScoreCalculationService} calculates points only for bets on those matches</li>
 * </ol>
 */
@ApplicationScoped
@Slf4j
public class MatchUpdateScheduler {

    @Inject
    FootballDataService footballDataService;

    @Inject
    ScoreCalculationService scoreCalculationService;

    @ConfigProperty(name = "bolao.schedules.matches.enabled", defaultValue = "true")
    boolean enabled;

    /**
     * Scheduled method that runs according to the configured cron expression.
     * Fetches match updates from football-data.org and calculates points
     * for any matches that just finished.
     *
     * <p>The method is a no-op when {@code bolao.schedules.matches.enabled} is false.
     */
    @Scheduled(cron = "${bolao.schedules.matches.schedule:0 0/1 * * * ?}",
               identity = "match-update-scheduler")
    void updateMatchesAndCalculateScores() {
        if (!enabled) {
            log.debug("Match update scheduler is disabled");
            return;
        }

        log.debug("Match update scheduler tick — checking for updates");

        try {
            // TODO: Inject a REST client for football-data.org and fetch the response.
            // For now the scheduler is wired up but the HTTP call is not yet implemented.
            // When the REST client is available, replace this with:
            //   FootballDataResponse response = footballDataClient.getMatches();
            //   List<UUID> newlyFinished = footballDataService.updateAllMatches(response);
            //   if (!newlyFinished.isEmpty()) {
            //       scoreCalculationService.calculatePointsForMatches(newlyFinished);
            //   }

            log.trace("Match update scheduler tick completed (REST client not yet configured)");
        } catch (Exception e) {
            log.error("Error during scheduled match update", e);
        }
    }

    /**
     * Manually triggers score calculation for specific matches.
     * Can be called from a REST endpoint for admin/manual triggers.
     *
     * @param matchIds the UUIDs of matches to recalculate
     * @return number of bets updated
     */
    public int triggerScoreCalculation(List<UUID> matchIds) {
        return scoreCalculationService.calculatePointsForMatches(matchIds);
    }
}
