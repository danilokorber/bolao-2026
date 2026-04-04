package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.Pool;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class PoolRepository implements PanacheRepositoryBase<Pool, UUID> {

    public Pool findByInviteCode(String inviteCode) {
        return find("inviteCode", inviteCode).firstResult();
    }

    public List<Pool> findActivePools() {
        return list("isActive", true);
    }

    public List<Pool> findByCreatedAtDesc() {
        return listAll(io.quarkus.panache.common.Sort.by("createdAt").descending());
    }
}
