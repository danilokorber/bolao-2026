package io.easyware.bolao.services;

import io.easyware.bolao.dto.NotificationPreferenceDTO;
import io.easyware.bolao.dto.PushSubscriptionRequestDTO;
import io.easyware.bolao.entities.*;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.enums.NotificationDeliveryStatus;
import io.easyware.bolao.enums.NotificationType;
import io.easyware.bolao.repositories.*;
import io.easyware.bolao.services.push.PushSendResult;
import io.easyware.bolao.services.push.WebPushSenderService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@ApplicationScoped
@Slf4j
public class NotificationService {

    @Inject
    NotificationPreferenceRepository preferenceRepository;

    @Inject
    PushSubscriptionRepository subscriptionRepository;

    @Inject
    NotificationDeliveryLogRepository deliveryLogRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    MatchRepository matchRepository;

    @Inject
    BetRepository betRepository;

    @Inject
    WebPushSenderService webPushSenderService;

    @ConfigProperty(name = "bolao.notifications.global-send-zone", defaultValue = "UTC")
    String globalSendZone;

    public NotificationPreferenceDTO getPreferences(UUID userId) {
        NotificationPreference preference = getOrCreatePreference(userId);
        return toDTO(preference);
    }

    @Transactional
    public NotificationPreferenceDTO updatePreferences(UUID userId, NotificationPreferenceDTO dto) {
        if (dto == null || dto.getDailyEnabled() == null || dto.getEventEnabled() == null) {
            throw new BadRequestException("dailyEnabled and eventEnabled are required");
        }
        NotificationPreference preference = getOrCreatePreference(userId);
        preference.setDailyEnabled(dto.getDailyEnabled());
        preference.setEventEnabled(dto.getEventEnabled());
        preference.setUpdatedAt(LocalDateTime.now());
        return toDTO(preference);
    }

    @Transactional
    public void upsertSubscription(UUID userId, PushSubscriptionRequestDTO request) {
        AppUser user = appUserRepository.findById(userId);
        if (user == null) {
            throw new NotFoundException("User not found with id: " + userId);
        }
        PushSubscription existing = subscriptionRepository.findByEndpoint(request.getEndpoint());
        if (existing != null) {
            existing.setUser(user);
            existing.setP256dhKey(request.getP256dhKey());
            existing.setAuthKey(request.getAuthKey());
            existing.setUserAgent(request.getUserAgent());
            existing.setActive(true);
            existing.setUpdatedAt(LocalDateTime.now());
            return;
        }

        PushSubscription subscription = PushSubscription.builder()
                .user(user)
                .endpoint(request.getEndpoint())
                .p256dhKey(request.getP256dhKey())
                .authKey(request.getAuthKey())
                .userAgent(request.getUserAgent())
                .active(true)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        subscriptionRepository.persist(subscription);
    }

    @Transactional
    public void deactivateSubscription(UUID userId, String endpoint) {
        PushSubscription subscription = subscriptionRepository.findByEndpoint(endpoint);
        if (subscription == null || !subscription.getUser().getId().equals(userId)) {
            throw new NotFoundException("Subscription not found for current user");
        }
        subscription.setActive(false);
        subscription.setUpdatedAt(LocalDateTime.now());
    }

    public boolean isPushAvailable() {
        return webPushSenderService.isPushEnabled();
    }

    public String getPublicKey() {
        return webPushSenderService.getPublicKey();
    }

    @Transactional
    public void sendDailySummaries() {
        List<AppUser> users = appUserRepository.findActiveUsers();
        LocalDate today = LocalDate.now(java.time.ZoneId.of(globalSendZone));
        for (AppUser user : users) {
            NotificationPreference preference = getOrCreatePreference(user.getId());
            if (!Boolean.TRUE.equals(preference.getDailyEnabled())) {
                continue;
            }
            String dedupKey = "daily:" + today + ":" + user.getId();
            if (deliveryLogRepository.existsByDedupKey(dedupKey)) {
                continue;
            }
            long totalPoints = calculateTotalPoints(user.getId());
            long upcoming = matchRepository.count("status", MatchStatus.SCHEDULED);
            String title = "Bolão 2026 - resumo diário";
            String body = "Você tem " + totalPoints + " pontos. Próximos jogos no torneio: " + upcoming + ".";
            sendToUser(user, NotificationType.DAILY_SUMMARY, dedupKey, title, body, "/dashboard");
        }
    }

    @Transactional
    public void sendMatchFinishedNotifications(List<UUID> changedMatchIds) {
        if (changedMatchIds == null || changedMatchIds.isEmpty()) {
            return;
        }
        List<Match> matches = matchRepository.list("id in ?1 and status = ?2", changedMatchIds, MatchStatus.FINISHED);
        for (Match match : matches) {
            List<Bet> bets = betRepository.findByMatch(match.getId());
            for (Bet bet : bets) {
                AppUser user = bet.getUser();
                if (user == null || Boolean.FALSE.equals(user.getActive())) {
                    continue;
                }
                NotificationPreference preference = getOrCreatePreference(user.getId());
                if (!Boolean.TRUE.equals(preference.getEventEnabled())) {
                    continue;
                }
                String dedupKey = "match-finished:" + match.getId() + ":" + user.getId();
                if (deliveryLogRepository.existsByDedupKey(dedupKey)) {
                    continue;
                }

                int points = bet.getCalculatedPoints();
                String title = "Jogo encerrado: " + match.getHomeTeam().getNamePt() + " x " + match.getAwayTeam().getNamePt();
                String body = "Seu palpite: " + bet.getHomeGoalsBet() + "x" + bet.getAwayGoalsBet() + ". Pontos no jogo: " + points + ".";
                sendToUser(user, NotificationType.MATCH_FINISHED, dedupKey, title, body, "/matches/" + match.getId());
            }
        }
    }

    private long calculateTotalPoints(UUID userId) {
        return betRepository.findByUser(userId).stream()
                .map(Bet::getPointsEarned)
                .filter(p -> p != null)
                .mapToLong(Integer::longValue)
                .sum();
    }

    private NotificationPreference getOrCreatePreference(UUID userId) {
        NotificationPreference preference = preferenceRepository.findByUserId(userId);
        if (preference != null) {
            return preference;
        }

        AppUser user = appUserRepository.findById(userId);
        if (user == null) {
            throw new NotFoundException("User not found with id: " + userId);
        }
        NotificationPreference created = NotificationPreference.builder()
                .user(user)
                .dailyEnabled(true)
                .eventEnabled(true)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        preferenceRepository.persist(created);
        return created;
    }

    private NotificationPreferenceDTO toDTO(NotificationPreference preference) {
        return NotificationPreferenceDTO.builder()
                .dailyEnabled(preference.getDailyEnabled())
                .eventEnabled(preference.getEventEnabled())
                .build();
    }

    private void sendToUser(AppUser user, NotificationType type, String dedupKey, String title, String body, String url) {
        List<PushSubscription> subscriptions = subscriptionRepository.findActiveByUserId(user.getId());
        if (subscriptions.isEmpty()) {
            log.debug("No active push subscriptions for user {}", user.getId());
            return;
        }

        NotificationDeliveryLog logEntry = NotificationDeliveryLog.builder()
                .user(user)
                .notificationType(type)
                .dedupKey(dedupKey)
                .title(title)
                .body(body)
                .status(NotificationDeliveryStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .build();
        deliveryLogRepository.persist(logEntry);

        String payload = buildPayload(title, body, url);
        boolean atLeastOneSent = false;
        for (PushSubscription subscription : subscriptions) {
            PushSendResult sendResult = webPushSenderService.send(subscription, payload);
            if (sendResult.success()) {
                atLeastOneSent = true;
                continue;
            }
            if (sendResult.subscriptionGone()) {
                subscription.setActive(false);
                subscription.setUpdatedAt(LocalDateTime.now());
            }
            log.warn("Push send failed for user {} endpoint {}: {}", user.getId(), subscription.getEndpoint(), sendResult.errorMessage());
        }

        if (atLeastOneSent) {
            logEntry.setStatus(NotificationDeliveryStatus.SENT);
            logEntry.setSentAt(LocalDateTime.now());
            return;
        }
        logEntry.setStatus(NotificationDeliveryStatus.FAILED);
        logEntry.setErrorMessage("All subscription deliveries failed");
    }

    private String buildPayload(String title, String body, String url) {
        return """
            {
              "notification": {
                "title": "%s",
                "body": "%s",
                "icon": "/fifawc2026_512.png",
                "badge": "/favicon.ico",
                "data": {
                  "onActionClick": {
                    "default": {
                      "operation": "openWindow",
                      "url": "%s"
                    }
                  }
                }
              }
            }
            """.formatted(escapeJson(title), escapeJson(body), escapeJson(url));
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
