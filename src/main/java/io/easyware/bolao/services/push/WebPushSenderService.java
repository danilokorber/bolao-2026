package io.easyware.bolao.services.push;

import io.easyware.bolao.entities.PushSubscription;
import jakarta.enterprise.context.ApplicationScoped;
import lombok.extern.slf4j.Slf4j;
import nl.martijndwars.webpush.Notification;
import nl.martijndwars.webpush.PushService;
import nl.martijndwars.webpush.Utils;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jose4j.lang.JoseException;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.util.concurrent.ExecutionException;

@ApplicationScoped
@Slf4j
public class WebPushSenderService {

    @ConfigProperty(name = "bolao.notifications.push.enabled", defaultValue = "true")
    boolean pushEnabled;

    @ConfigProperty(name = "bolao.notifications.push.vapid.public-key", defaultValue = "")
    String vapidPublicKey;

    @ConfigProperty(name = "bolao.notifications.push.vapid.private-key", defaultValue = "")
    String vapidPrivateKey;

    @ConfigProperty(name = "bolao.notifications.push.vapid.subject", defaultValue = "mailto:admin@example.com")
    String vapidSubject;

    public boolean isPushEnabled() {
        return pushEnabled && isConfiguredVapidKey(vapidPublicKey) && isConfiguredVapidKey(vapidPrivateKey);
    }

    public String getPublicKey() {
        return isConfiguredVapidKey(vapidPublicKey) ? vapidPublicKey : "";
    }

    public PushSendResult send(PushSubscription subscription, String payload) {
        if (!isPushEnabled()) {
            return PushSendResult.failed("Push notifications are disabled");
        }
        try {
            PushService pushService = new PushService();
            pushService.setPublicKey(Utils.loadPublicKey(vapidPublicKey));
            pushService.setPrivateKey(vapidPrivateKey);
            pushService.setSubject(vapidSubject);

            Notification notification = new Notification(
                    subscription.getEndpoint(),
                    subscription.getP256dhKey(),
                    subscription.getAuthKey(),
                    payload.getBytes(StandardCharsets.UTF_8)
            );

            var response = pushService.send(notification);
            int status = response.getStatusLine().getStatusCode();
            if (status == 404 || status == 410) {
                return PushSendResult.gone();
            }
            if (status >= 200 && status < 300) {
                return PushSendResult.sent();
            }
            return PushSendResult.failed("Web push response status: " + status);
        } catch (GeneralSecurityException | IOException | JoseException | InterruptedException | ExecutionException e) {
            log.warn("Failed sending push notification", e);
            return PushSendResult.failed(e.getMessage());
        }
    }

    private boolean isConfiguredVapidKey(String value) {
        return value != null && !value.isBlank() && !"__not_configured__".equals(value);
    }
}
