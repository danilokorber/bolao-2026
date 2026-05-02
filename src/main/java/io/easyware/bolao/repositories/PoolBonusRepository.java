package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.PoolBonus;
import io.easyware.bolao.enums.BonusType;
import io.easyware.bolao.enums.TournamentRound;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class PoolBonusRepository implements PanacheRepositoryBase<PoolBonus, UUID> {

    public List<PoolBonus> findByPool(UUID poolId) {
        return list("pool.id", poolId);
    }

    public List<PoolBonus> findByPoolAndRound(UUID poolId, TournamentRound round) {
        return list("pool.id = ?1 and tournamentRound = ?2", poolId, round);
    }

    public boolean existsByPoolAndTypeAndRound(UUID poolId, BonusType type, TournamentRound round) {
        return count("pool.id = ?1 and bonusType = ?2 and tournamentRound = ?3", poolId, type, round) > 0;
    }
}
