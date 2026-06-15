package io.easyware.bolao.resources;

import io.easyware.bolao.dto.FavoriteToggleRequestDTO;
import io.easyware.bolao.dto.FavoriteToggleResponseDTO;
import io.easyware.bolao.services.AppUserService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.NotAuthorizedException;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.SecurityContext;

@Path("/api/favorite")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class FavoriteResource {

    @Inject
    AppUserService appUserService;

    @Context
    SecurityContext securityContext;

    @POST
    public FavoriteToggleResponseDTO toggleFavorite(@Valid FavoriteToggleRequestDTO request) {
        if (securityContext.getUserPrincipal() == null || securityContext.getUserPrincipal().getName() == null) {
            throw new NotAuthorizedException("Missing authenticated principal");
        }
        String currentUserEmail = securityContext.getUserPrincipal().getName();
        return appUserService.toggleFavorite(currentUserEmail, request.getFavoriteUserId());
    }
}
