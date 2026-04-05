package io.easyware.bolao.resources;

import io.easyware.bolao.services.ScoreCalculationService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Admin endpoint for triggering score calculations.
 *
 * <p>These endpoints are intended for manual intervention (e.g. correcting scores,
 * re-running calculation after a bug fix). During normal operation, the
 * {@link io.easyware.bolao.schedules.MatchUpdateScheduler} handles this automatically.
 *
 * <h3>Endpoints</h3>
 * <ul>
 *   <li>{@code POST /v1/admin/scores/calculate} — calculate points for specific matches</li>
 *   <li>{@code POST /v1/admin/scores/recalculate/{matchId}} — recalculate points for one match</li>
 *   <li>{@code POST /v1/admin/scores/recalculate-all} — recalculate points for all matches with a result</li>
 * </ul>
 */
@Slf4j
@Path("/v1/admin/scores")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ScoreResource {

    @Inject
    ScoreCalculationService scoreCalculationService;

    /**
     * Calculates points for bets on the given match UUIDs.
     * Only processes matches that are in FINISHED status.
     *
     * @param matchIds list of match UUIDs to process
     * @return summary with the number of bets updated
     *
     * <p>Response codes:
     * <ul>
     *   <li>200 — calculation completed (even if 0 bets updated)</li>
     *   <li>400 — empty or null match ID list</li>
     * </ul>
     */
    @POST
    @Path("/calculate")
    public Response calculatePoints(List<UUID> matchIds) {
        if (matchIds == null || matchIds.isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "matchIds list must not be empty"))
                    .build();
        }

        log.info("Manual score calculation requested for {} match(es)", matchIds.size());
        int updated = scoreCalculationService.calculatePointsForMatches(matchIds);

        return Response.ok(Map.of(
                "matchesProcessed", matchIds.size(),
                "betsUpdated", updated
        )).build();
    }

    /**
     * Recalculates points for ALL bets on a single match.
     * Overwrites previously computed points — useful when a match score is corrected.
     *
     * @param matchId the match UUID
     * @return summary with the number of bets updated
     *
     * <p>Response codes:
     * <ul>
     *   <li>200 — recalculation completed</li>
     *   <li>404 — match not found</li>
     * </ul>
     */
    @POST
    @Path("/recalculate/{matchId}")
    public Response recalculateForMatch(@PathParam("matchId") UUID matchId) {
        log.info("Manual recalculation requested for match {}", matchId);
        int updated = scoreCalculationService.recalculateForMatch(matchId);

        return Response.ok(Map.of(
                "matchId", matchId,
                "betsUpdated", updated
        )).build();
    }

    /**
     * Recalculates points for ALL bets on every match that has a result (LIVE or FINISHED).
     * Useful after a bug fix, scoring rule change, or initial data seeding.
     *
     * <p>Response codes:
     * <ul>
     *   <li>200 — recalculation completed</li>
     * </ul>
     */
    @POST
    @Path("/recalculate-all")
    public Response recalculateAll() {
        log.info("Full recalculation requested for all matches with results");
        ScoreCalculationService.RecalculateAllResult result = scoreCalculationService.recalculateAll();

        return Response.ok(Map.of(
                "matchesProcessed", result.matchesProcessed(),
                "betsUpdated", result.betsUpdated()
        )).build();
    }
}
