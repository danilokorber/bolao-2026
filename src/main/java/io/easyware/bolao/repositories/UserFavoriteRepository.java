package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.UserFavorite;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.UUID;

@ApplicationScoped
public class UserFavoriteRepository implements PanacheRepositoryBase<UserFavorite, UUID> {

    public UserFavorite findByUserAndFavoriteUser(UUID userId, UUID favoriteUserId) {
        return find("user.id = ?1 and favoriteUser.id = ?2", userId, favoriteUserId).firstResult();
    }
}
