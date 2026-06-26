package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "route_visit", indexes = {
    @Index(name = "idx_route_visit_user", columnList = "user_id"),
    @Index(name = "idx_route_visit_session", columnList = "session_id"),
    @Index(name = "idx_route_visit_created", columnList = "created_at")
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RouteVisit {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Column(name = "username", nullable = false, length = 100)
    private String username;

    @Column(name = "session_id", nullable = false, length = 64)
    private String sessionId;

    @Column(name = "path", nullable = false, length = 512)
    private String path;

    @Column(name = "screen_width")
    private Integer screenWidth;

    @Column(name = "screen_height")
    private Integer screenHeight;

    @Column(name = "viewport_width")
    private Integer viewportWidth;

    @Column(name = "viewport_height")
    private Integer viewportHeight;

    @Column(name = "device_pixel_ratio")
    private Double devicePixelRatio;

    @Column(name = "browser_name", length = 64)
    private String browserName;

    @Column(name = "browser_version", length = 64)
    private String browserVersion;

    @Column(name = "os_name", length = 64)
    private String osName;

    @Column(name = "language", length = 32)
    private String language;

    @Column(name = "timezone", length = 64)
    private String timezone;

    @Column(name = "referrer", columnDefinition = "TEXT")
    private String referrer;

    @Column(name = "user_agent", columnDefinition = "TEXT")
    private String userAgent;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
