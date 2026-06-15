package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.AppUserFavorite;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class AppUserFavoriteRepository implements PanacheRepositoryBase<AppUserFavorite, UUID> {

    public List<AppUserFavorite> findByUserId(UUID userId) {
        return list("userId", userId);
    }

    public List<AppUserFavorite> findByFavoriteId(UUID favoriteId) {
        return list("favoriteId", favoriteId);
    }

    public AppUserFavorite findByUserIdAndFavoriteId(UUID userId, UUID favoriteId) {
        return find("userId = ?1 and favoriteId = ?2", userId, favoriteId).firstResult();
    }

    public void deleteByUserIdAndFavoriteId(UUID userId, UUID favoriteId) {
        delete("userId = ?1 and favoriteId = ?2", userId, favoriteId);
    }
}
