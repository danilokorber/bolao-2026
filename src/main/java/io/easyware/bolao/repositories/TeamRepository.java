package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.GroupName;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class TeamRepository implements PanacheRepositoryBase<Team, UUID> {

    public List<Team> findByGroup(GroupName groupName) {
        return list("groupName", groupName);
    }

    public Team findByFifaCode(String fifaCode) {
        return find("fifaCode", fifaCode).firstResult();
    }
}
