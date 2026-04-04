package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.ChampionBet;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.UUID;

@ApplicationScoped
public class ChampionBetRepository implements PanacheRepositoryBase<ChampionBet, UUID> {

    public ChampionBet findByUser(UUID userId) {
        return find("user.id", userId).firstResult();
    }

    public long countByChampionTeam(UUID teamId) {
        return count("championTeam.id", teamId);
    }

    public long countByRunnerUpTeam(UUID teamId) {
        return count("runnerUpTeam.id", teamId);
    }
}
