package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "app_user_favorite", indexes = {
    @Index(name = "idx_user_id", columnList = "user_id"),
    @Index(name = "idx_favorite_id", columnList = "favorite_id")
}, uniqueConstraints = {
    @UniqueConstraint(name = "uk_user_favorite", columnNames = {"user_id", "favorite_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppUserFavorite {

    @Id
    @UUIDv7
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "favorite_id", nullable = false)
    private UUID favoriteId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", insertable = false, updatable = false, 
                foreignKey = @ForeignKey(name = "fk_user_id"))
    private AppUser user;
}
