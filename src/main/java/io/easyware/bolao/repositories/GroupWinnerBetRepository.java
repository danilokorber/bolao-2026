package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.GroupWinnerBet;
import io.easyware.bolao.enums.GroupName;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class GroupWinnerBetRepository implements PanacheRepositoryBase<GroupWinnerBet, UUID> {

    public List<GroupWinnerBet> findByUser(UUID userId) {
        return list("user.id", userId);
    }

    public List<GroupWinnerBet> findByGroup(GroupName groupName) {
        return list("groupName", groupName);
    }

    public GroupWinnerBet findByUserAndGroup(UUID userId, GroupName groupName) {
        return find("user.id = ?1 and groupName = ?2", userId, groupName).firstResult();
    }
}
