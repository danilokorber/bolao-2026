package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.PushSubscription;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class PushSubscriptionRepository implements PanacheRepositoryBase<PushSubscription, UUID> {

    public PushSubscription findByEndpoint(String endpoint) {
        return find("endpoint", endpoint).firstResult();
    }

    public List<PushSubscription> findActiveByUserId(UUID userId) {
        return list("user.id = ?1 and active = true", userId);
    }

    public List<PushSubscription> findAllActive() {
        return list("active", true);
    }
}
