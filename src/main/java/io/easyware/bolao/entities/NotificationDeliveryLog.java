package io.easyware.bolao.entities;

import io.easyware.bolao.enums.NotificationDeliveryStatus;
import io.easyware.bolao.enums.NotificationType;
import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "notification_delivery_log", indexes = {
    @Index(name = "idx_notification_delivery_user", columnList = "user_id"),
    @Index(name = "idx_notification_delivery_type", columnList = "notification_type"),
    @Index(name = "idx_notification_delivery_status", columnList = "status"),
    @Index(name = "idx_notification_delivery_dedup", columnList = "dedup_key")
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationDeliveryLog {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Enumerated(EnumType.STRING)
    @Column(name = "notification_type", nullable = false, length = 32)
    private NotificationType notificationType;

    @Column(name = "dedup_key", nullable = false, unique = true, length = 255)
    private String dedupKey;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "body", nullable = false, columnDefinition = "TEXT")
    private String body;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 32)
    private NotificationDeliveryStatus status;

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "sent_at")
    private LocalDateTime sentAt;
}
