package io.easyware.bolao.resources;

import io.easyware.bolao.dto.NotificationPreferenceDTO;
import io.easyware.bolao.dto.PushPublicKeyDTO;
import io.easyware.bolao.dto.PushSubscriptionRequestDTO;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.services.NotificationService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.util.Map;
import java.util.UUID;

@Path("/v1/notifications")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class NotificationResource {

    @Inject
    NotificationService notificationService;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    JsonWebToken jwt;

    @GET
    @Path("/preferences")
    public NotificationPreferenceDTO getPreferences() {
        UUID currentUserId = currentUserId();
        return notificationService.getPreferences(currentUserId);
    }

    @PUT
    @Path("/preferences")
    public NotificationPreferenceDTO updatePreferences(@Valid NotificationPreferenceDTO dto) {
        UUID currentUserId = currentUserId();
        return notificationService.updatePreferences(currentUserId, dto);
    }

    @GET
    @Path("/push/public-key")
    public PushPublicKeyDTO getPublicPushKey() {
        return PushPublicKeyDTO.builder()
                .enabled(notificationService.isPushAvailable())
                .publicKey(notificationService.getPublicKey())
                .build();
    }

    @POST
    @Path("/push/subscriptions")
    public Response subscribe(@Valid PushSubscriptionRequestDTO request) {
        UUID currentUserId = currentUserId();
        notificationService.upsertSubscription(currentUserId, request);
        return Response.ok(Map.of("status", "subscribed")).build();
    }

    @DELETE
    @Path("/push/subscriptions")
    public Response unsubscribe(@QueryParam("endpoint") String endpoint) {
        if (endpoint == null || endpoint.isBlank()) {
            throw new BadRequestException("endpoint query parameter is required");
        }
        UUID currentUserId = currentUserId();
        notificationService.deactivateSubscription(currentUserId, endpoint);
        return Response.ok(Map.of("status", "unsubscribed")).build();
    }

    private UUID currentUserId() {
        String keycloakId = jwt.getSubject();
        if (keycloakId == null || keycloakId.isBlank()) {
            throw new NotAuthorizedException("Missing JWT subject");
        }
        AppUser user = appUserRepository.findByKeycloakId(keycloakId);
        if (user == null) {
            throw new NotFoundException("Current user not registered");
        }
        return user.getId();
    }
}
