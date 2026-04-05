package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.Bet;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class BetRepository implements PanacheRepositoryBase<Bet, UUID> {

    public List<Bet> findByUser(UUID userId) {
        return list("user.id", userId);
    }

    public List<Bet> findByMatch(UUID matchId) {
        return list("match.id", matchId);
    }

    public Bet findByUserAndMatch(UUID userId, UUID matchId) {
        return find("user.id = ?1 and match.id = ?2", userId, matchId).firstResult();
    }

    public List<Bet> findTopScorers(int limit) {
        return find("order by pointsEarned desc")
                .page(0, limit)
                .list();
    }

    public long getTotalPointsByUser(UUID userId) {
        return find("select sum(b.pointsEarned) from Bet b where b.user.id = ?1", userId)
                .project(Long.class)
                .firstResult();
    }

    /**
     * Finds all bets for a given set of match UUIDs.
     * Used to efficiently recalculate points only for bets on recently finished matches.
     *
     * @param matchIds the match UUIDs whose bets should be fetched
     * @return all bets placed on any of the given matches
     */
    public List<Bet> findByMatchIds(List<UUID> matchIds) {
        if (matchIds == null || matchIds.isEmpty()) {
            return List.of();
        }
        return list("match.id in ?1", matchIds);
    }

    /**
     * Counts bets for a given match that have not yet been scored (points still 0).
     *
     * @param matchId the match UUID
     * @return number of unscored bets for this match
     */
    public long countUnscoredByMatch(UUID matchId) {
        return count("match.id = ?1 and pointsEarned = 0", matchId);
    }
}
