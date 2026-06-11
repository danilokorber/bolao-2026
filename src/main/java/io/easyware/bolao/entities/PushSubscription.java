package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "push_subscription", indexes = {
    @Index(name = "idx_push_subscription_user", columnList = "user_id"),
    @Index(name = "idx_push_subscription_active", columnList = "active"),
    @Index(name = "idx_push_subscription_endpoint", columnList = "endpoint")
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PushSubscription {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Column(name = "endpoint", nullable = false, unique = true, columnDefinition = "TEXT")
    private String endpoint;

    @Column(name = "p256dh_key", nullable = false, length = 512)
    private String p256dhKey;

    @Column(name = "auth_key", nullable = false, length = 512)
    private String authKey;

    @Column(name = "user_agent", length = 512)
    private String userAgent;

    @Column(name = "active", nullable = false)
    @Builder.Default
    private Boolean active = true;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();
}
