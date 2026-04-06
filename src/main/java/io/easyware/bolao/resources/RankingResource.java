package io.easyware.bolao.resources;

import io.easyware.bolao.dto.RankingEntryDTO;
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
public class RankingResource {

    @Inject
    EntityManager em;

    @GET
    public List<RankingEntryDTO> getRanking() {
        String sql = """
            SELECT u.id, u.name,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.points_earned = 10), 0) AS count_10,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.points_earned = 5), 0) AS count_5,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.points_earned = 3), 0) AS count_3,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.points_earned = 1), 0) AS count_1,
                COALESCE((SELECT COUNT(*) FROM bet b WHERE b.user_id = u.id AND b.points_earned = -3), 0) AS count_neg,
                COALESCE((SELECT SUM(g.points_earned) FROM group_winner_bet g WHERE g.user_id = u.id), 0) +
                COALESCE((SELECT SUM(c.bonus_points) FROM champion_bet c WHERE c.user_id = u.id), 0) AS special_points,
                COALESCE((SELECT SUM(b.points_earned) FROM bet b WHERE b.user_id = u.id), 0) +
                COALESCE((SELECT SUM(g.points_earned) FROM group_winner_bet g WHERE g.user_id = u.id), 0) +
                COALESCE((SELECT SUM(c.bonus_points) FROM champion_bet c WHERE c.user_id = u.id), 0) AS total_points
            FROM app_user u
            WHERE u.active = true
            ORDER BY total_points DESC, u.name ASC
            """;

        List<Tuple> results = em.createNativeQuery(sql, Tuple.class).getResultList();

        List<RankingEntryDTO> ranking = new ArrayList<>();
        int position = 1;
        for (Tuple row : results) {
            ranking.add(RankingEntryDTO.builder()
                    .position(position++)
                    .userId((UUID) row.get("id"))
                    .userName((String) row.get("name"))
                    .count10(((Number) row.get("count_10")).longValue())
                    .count5(((Number) row.get("count_5")).longValue())
                    .count3(((Number) row.get("count_3")).longValue())
                    .count1(((Number) row.get("count_1")).longValue())
                    .countNeg(((Number) row.get("count_neg")).longValue())
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
    @GET
    @Path("/history")
    public List<Map<String, Object>> getRankingHistory() {
        // 1. Match bet points per matchday
        String matchSql = """
            SELECT DATE(m.match_datetime) AS matchday, b.user_id, u.name AS user_name,
                   SUM(b.points_earned) AS day_points
            FROM bet b
            JOIN match m ON b.match_id = m.id
            JOIN app_user u ON b.user_id = u.id
            WHERE m.status = 'FINISHED' AND u.active = true
            GROUP BY DATE(m.match_datetime), b.user_id, u.name
            """;

        // 2. Group winner bet points, attributed to last finished match date of each group
        String groupSql = """
            SELECT g.user_id, u.name AS user_name, g.points_earned AS day_points,
                   (SELECT MAX(DATE(m.match_datetime)) FROM match m
                    WHERE m.stage = CAST(g.group_name AS TEXT) AND m.status = 'FINISHED') AS matchday
            FROM group_winner_bet g
            JOIN app_user u ON g.user_id = u.id
            WHERE g.points_earned != 0 AND u.active = true
            """;

        // 3. Champion bet points, attributed to last finished match date overall
        String championSql = """
            SELECT c.user_id, u.name AS user_name, c.bonus_points AS day_points,
                   (SELECT MAX(DATE(m.match_datetime)) FROM match m WHERE m.status = 'FINISHED') AS matchday
            FROM champion_bet c
            JOIN app_user u ON c.user_id = u.id
            WHERE c.bonus_points != 0 AND u.active = true
            """;

        // Aggregate all points into: matchday -> userId -> (userName, dayPoints)
        Map<LocalDate, Map<UUID, long[]>> dayMap = new TreeMap<>();
        Map<UUID, String> nameByUser = new LinkedHashMap<>();

        for (String sql : List.of(matchSql, groupSql, championSql)) {
            List<Tuple> results = em.createNativeQuery(sql, Tuple.class).getResultList();
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
