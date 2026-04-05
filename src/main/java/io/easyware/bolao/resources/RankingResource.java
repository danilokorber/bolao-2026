package io.easyware.bolao.resources;

import io.easyware.bolao.dto.RankingEntryDTO;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Tuple;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import lombok.extern.java.Log;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
                    .specialPoints(((Number) row.get("special_points")).longValue())
                    .totalPoints(((Number) row.get("total_points")).longValue())
                    .build());
        }
        return ranking;
    }
}
