package io.easyware.bolao.entities;

import io.easyware.bolao.enums.UserPoolStatus;
import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "user_pool",
       uniqueConstraints = {
           @UniqueConstraint(name = "idx_user_pool_unique", columnNames = {"user_id", "pool_id"})
       },
       indexes = {
           @Index(name = "idx_user_pool_user", columnList = "user_id"),
           @Index(name = "idx_user_pool_pool", columnList = "pool_id"),
           @Index(name = "idx_user_pool_status", columnList = "status")
       })
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserPool {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pool_id", nullable = false)
    private Pool pool;

    @Column(name = "joined_at", nullable = false)
    @Builder.Default
    private LocalDateTime joinedAt = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private UserPoolStatus status = UserPoolStatus.PENDING;
}
