package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.NotificationDeliveryLog;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.UUID;

@ApplicationScoped
public class NotificationDeliveryLogRepository implements PanacheRepositoryBase<NotificationDeliveryLog, UUID> {

    public boolean existsByDedupKey(String dedupKey) {
        return count("dedupKey", dedupKey) > 0;
    }
}
