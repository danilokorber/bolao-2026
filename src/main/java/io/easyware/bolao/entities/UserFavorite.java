package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "user_favorite",
       uniqueConstraints = {
           @UniqueConstraint(name = "idx_user_favorite_unique", columnNames = {"user_id", "favorite_user_id"})
       },
       indexes = {
           @Index(name = "idx_user_favorite_user", columnList = "user_id"),
           @Index(name = "idx_user_favorite_target", columnList = "favorite_user_id")
       })
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserFavorite {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "favorite_user_id", nullable = false)
    private AppUser favoriteUser;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
