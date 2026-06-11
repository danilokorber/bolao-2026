package io.easyware.bolao.resources;

import io.easyware.bolao.enums.NotificationDeliveryStatus;
import io.easyware.bolao.repositories.NotificationDeliveryLogRepository;
import io.easyware.bolao.repositories.PushSubscriptionRepository;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.Map;

@Path("/v1/admin/notifications")
@Produces(MediaType.APPLICATION_JSON)
@RolesAllowed("admin")
public class AdminNotificationResource {

    @Inject
    NotificationDeliveryLogRepository deliveryLogRepository;

    @Inject
    PushSubscriptionRepository pushSubscriptionRepository;

    @GET
    @Path("/stats")
    public Map<String, Object> getStats() {
        return Map.of(
                "activeSubscriptions", pushSubscriptionRepository.count("active", true),
                "deliveriesSent", deliveryLogRepository.count("status", NotificationDeliveryStatus.SENT),
                "deliveriesFailed", deliveryLogRepository.count("status", NotificationDeliveryStatus.FAILED)
        );
    }
}
