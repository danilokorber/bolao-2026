package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "notification_preference", indexes = {
    @Index(name = "idx_notification_preference_user", columnList = "user_id")
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationPreference {

    @Id
    @UUIDv7
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private AppUser user;

    @Column(name = "daily_enabled", nullable = false)
    @Builder.Default
    private Boolean dailyEnabled = true;

    @Column(name = "event_enabled", nullable = false)
    @Builder.Default
    private Boolean eventEnabled = true;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();
}
