package io.easyware.bolao.resources;

import io.easyware.bolao.dto.RouteVisitRequestDTO;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.services.RouteVisitService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.util.UUID;

@Path("/v1/route-visits")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class RouteVisitResource {

    @Inject
    RouteVisitService routeVisitService;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    JsonWebToken jwt;

    @POST
    public Response track(@Valid RouteVisitRequestDTO request) {
        UUID currentUserId = currentUserId();
        routeVisitService.record(currentUserId, request);
        return Response.noContent().build();
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
