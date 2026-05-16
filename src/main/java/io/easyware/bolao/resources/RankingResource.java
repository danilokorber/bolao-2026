package io.easyware.bolao.resources;

import io.easyware.bolao.dto.RankingEntryDTO;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Tuple;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import lombok.extern.java.Log;

import java.time.LocalDate;
import java.util.*;

@Log
@Path("/v1/ranking")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class RankingResource {

    @Inject
    EntityManager em;

    @GET
    public List<RankingEntryDTO> getRanking() {
        return buildRanking(null);
    }

    @GET
    @Path("/pool/{poolId}")
    public List<RankingEntryDTO> getRankingByPool(@PathParam("poolId") UUID poolId) {
        return buildRanking(poolId);
    }

    @GET
    @Path("/history")
    public List<Map<String, Object>> getRankingHistory() {
        return buildRankingHistory(null);
    }

    @GET
    @Path("/pool/{poolId}/history")
    public List<Map<String, Object>> getRankingHistoryByPool(@PathParam("poolId") UUID poolId) {
        return buildRankingHistory(poolId);
    }

    private List<RankingEntryDTO> buildRanking(UUID poolId) {
        boolean poolScoped = poolId != null;
        String poolJoin = poolScoped
                ? "JOIN user_pool up ON up.user_id = u.id AND up.pool_id = :poolId AND up.status = 'ACTIVE'"
                : "";

        String sql = """
            SELECT u.id, u.name,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.score_tier = 'EXACT'), 0) AS count_exact,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.score_tier = 'DIFF'), 0) AS count_diff,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.score_tier = 'WINNER'), 0) AS count_winner,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.score_tier = 'INVERTED'), 0) AS count_inverted,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.score_tier = 'WRONG'), 0) AS count_wrong,
                COALESCE((SELECT SUM(g.points_earned) FROM group_winner_bet g WHERE g.user_id = u.id), 0) +
                COALESCE((SELECT SUM(c.bonus_points) FROM champion_bet c WHERE c.user_id = u.id), 0) AS special_points,
                COALESCE((SELECT SUM(b.points_earned) FROM bet b WHERE b.user_id = u.id), 0) +
                COALESCE((SELECT SUM(g.points_earned) FROM group_winner_bet g WHERE g.user_id = u.id), 0) +
                COALESCE((SELECT SUM(c.bonus_points) FROM champion_bet c WHERE c.user_id = u.id), 0) AS total_points
            FROM app_user u
            %s
            WHERE u.active = true
            ORDER BY total_points DESC, u.name ASC
            """.formatted(poolJoin);

        var query = em.createNativeQuery(sql, Tuple.class);
        if (poolScoped) {
            query.setParameter("poolId", poolId);
        }

        List<Tuple> results = query.getResultList();

        List<RankingEntryDTO> ranking = new ArrayList<>();
        int position = 1;
        for (Tuple row : results) {
            ranking.add(RankingEntryDTO.builder()
                    .position(position++)
                    .userId((UUID) row.get("id"))
                    .userName((String) row.get("name"))
                    .countExact(((Number) row.get("count_exact")).longValue())
                    .countDiff(((Number) row.get("count_diff")).longValue())
                    .countWinner(((Number) row.get("count_winner")).longValue())
                    .countInverted(((Number) row.get("count_inverted")).longValue())
                    .countWrong(((Number) row.get("count_wrong")).longValue())
                    .specialPoints(((Number) row.get("special_points")).longValue())
                    .totalPoints(((Number) row.get("total_points")).longValue())
                    .build());
        }
        return ranking;
    }

    /**
     * Returns cumulative points per user per matchday, for building progression charts.
     * Each entry has: matchday (date string), userId, userName, cumulativePoints.
     * Includes match bet points, group winner bet points, and champion bet points.
     */
    private List<Map<String, Object>> buildRankingHistory(UUID poolId) {
        boolean poolScoped = poolId != null;
        String poolFilter = poolScoped
                ? "AND u.id IN (SELECT up.user_id FROM user_pool up WHERE up.pool_id = :poolId AND up.status = 'ACTIVE')"
                : "";

        // 1. Match bet points per matchday
        String matchSql = """
            SELECT DATE(m.match_datetime) AS matchday, b.user_id, u.name AS user_name,
                   SUM(b.points_earned) AS day_points
            FROM bet b
            JOIN match m ON b.match_id = m.id
            JOIN app_user u ON b.user_id = u.id
            WHERE m.status = 'FINISHED' AND u.active = true %s
            GROUP BY DATE(m.match_datetime), b.user_id, u.name
            """.formatted(poolFilter);

        // 2. Group winner bet points, attributed to last finished match date of each group
        String groupSql = """
            SELECT g.user_id, u.name AS user_name, g.points_earned AS day_points,
                   (SELECT MAX(DATE(m.match_datetime)) FROM match m
                    WHERE m.stage = CAST(g.group_name AS TEXT) AND m.status = 'FINISHED') AS matchday
            FROM group_winner_bet g
            JOIN app_user u ON g.user_id = u.id
            WHERE g.points_earned != 0 AND u.active = true %s
            """.formatted(poolFilter);

        // 3. Champion bet points, attributed to last finished match date overall
        String championSql = """
            SELECT c.user_id, u.name AS user_name, c.bonus_points AS day_points,
                   (SELECT MAX(DATE(m.match_datetime)) FROM match m WHERE m.status = 'FINISHED') AS matchday
            FROM champion_bet c
            JOIN app_user u ON c.user_id = u.id
            WHERE c.bonus_points != 0 AND u.active = true %s
            """.formatted(poolFilter);

        // Aggregate all points into: matchday -> userId -> (userName, dayPoints)
        Map<LocalDate, Map<UUID, long[]>> dayMap = new TreeMap<>();
        Map<UUID, String> nameByUser = new LinkedHashMap<>();

        for (String sql : List.of(matchSql, groupSql, championSql)) {
            var query = em.createNativeQuery(sql, Tuple.class);
            if (poolScoped) {
                query.setParameter("poolId", poolId);
            }
            List<Tuple> results = query.getResultList();
            for (Tuple row : results) {
                Object matchdayObj = row.get("matchday");
                if (matchdayObj == null) continue;
                LocalDate matchday = matchdayObj instanceof LocalDate ld ? ld : LocalDate.parse(matchdayObj.toString());
                UUID userId = (UUID) row.get("user_id");
                String userName = (String) row.get("user_name");
                long dayPoints = ((Number) row.get("day_points")).longValue();

                nameByUser.put(userId, userName);
                dayMap.computeIfAbsent(matchday, k -> new LinkedHashMap<>())
                      .merge(userId, new long[]{dayPoints}, (a, b) -> { a[0] += b[0]; return a; });
            }
        }

        // Build cumulative sums per user across matchdays
        Map<UUID, Long> cumulativeByUser = new LinkedHashMap<>();
        List<Map<String, Object>> history = new ArrayList<>();

        for (Map.Entry<LocalDate, Map<UUID, long[]>> dayEntry : dayMap.entrySet()) {
            LocalDate matchday = dayEntry.getKey();
            for (Map.Entry<UUID, long[]> userEntry : dayEntry.getValue().entrySet()) {
                UUID userId = userEntry.getKey();
                long dayPoints = userEntry.getValue()[0];

                long cumulative = cumulativeByUser.getOrDefault(userId, 0L) + dayPoints;
                cumulativeByUser.put(userId, cumulative);

                Map<String, Object> entry = new LinkedHashMap<>();
                entry.put("matchday", matchday.toString());
                entry.put("userId", userId.toString());
                entry.put("userName", nameByUser.get(userId));
                entry.put("cumulativePoints", cumulative);
                history.add(entry);
            }
        }

        return history;
    }
}
