package io.easyware.bolao.schedules;

import io.easyware.bolao.services.NotificationService;
import io.quarkus.scheduler.Scheduled;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@ApplicationScoped
@Slf4j
public class NotificationScheduler {

    @Inject
    NotificationService notificationService;

    @ConfigProperty(name = "bolao.notifications.enabled", defaultValue = "false")
    boolean notificationsEnabled;

    @ConfigProperty(name = "bolao.notifications.daily.enabled", defaultValue = "false")
    boolean dailyEnabled;

    @ConfigProperty(name = "bolao.notifications.daily.time", defaultValue = "08:00")
    String dailyTime;

    @ConfigProperty(name = "bolao.notifications.global-send-zone", defaultValue = "UTC")
    String globalSendZone;

    @Scheduled(every = "60s", identity = "daily-notification-scheduler")
    void processDailyNotifications() {
        if (!notificationsEnabled || !dailyEnabled) {
            return;
        }
        ZoneId zoneId = ZoneId.of(globalSendZone);
        ZonedDateTime now = ZonedDateTime.now(zoneId);
        LocalTime configured = LocalTime.parse(dailyTime);
        if (now.getHour() != configured.getHour() || now.getMinute() != configured.getMinute()) {
            return;
        }
        log.info("Running daily notifications for zone {} at {}", globalSendZone, now.toLocalTime());
        notificationService.sendDailySummaries();
    }
}
