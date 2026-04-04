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
}
