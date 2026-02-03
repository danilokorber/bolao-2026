package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.AppUser;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class AppUserRepository implements PanacheRepositoryBase<AppUser, UUID> {

    public AppUser findByKeycloakId(String keycloakId) {
        return find("keycloakId", keycloakId).firstResult();
    }

    public AppUser findByEmail(String email) {
        return find("email", email).firstResult();
    }

    public List<AppUser> findActiveUsers() {
        return list("active", true);
    }
}
