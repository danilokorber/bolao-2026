package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.UserPool;
import io.easyware.bolao.enums.UserPoolStatus;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class UserPoolRepository implements PanacheRepositoryBase<UserPool, UUID> {

    public List<UserPool> findByUser(UUID userId) {
        return list("user.id", userId);
    }

    public List<UserPool> findByPool(UUID poolId) {
        return list("pool.id", poolId);
    }

    public UserPool findByUserAndPool(UUID userId, UUID poolId) {
        return find("user.id = ?1 and pool.id = ?2", userId, poolId).firstResult();
    }

    public List<UserPool> findByUserAndStatus(UUID userId, UserPoolStatus status) {
        return list("user.id = ?1 and status = ?2", userId, status);
    }

    public List<UserPool> findByPoolAndStatus(UUID poolId, UserPoolStatus status) {
        return list("pool.id = ?1 and status = ?2", poolId, status);
    }

    public long countActiveMembers(UUID poolId) {
        return count("pool.id = ?1 and status = ?2", poolId, UserPoolStatus.ACTIVE);
    }
}
