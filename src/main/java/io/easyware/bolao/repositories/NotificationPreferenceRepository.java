package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.NotificationPreference;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.UUID;

@ApplicationScoped
public class NotificationPreferenceRepository implements PanacheRepositoryBase<NotificationPreference, UUID> {

    public NotificationPreference findByUserId(UUID userId) {
        return find("user.id", userId).firstResult();
    }
}
