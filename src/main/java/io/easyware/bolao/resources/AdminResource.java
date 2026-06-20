package io.easyware.bolao.resources;

import io.easyware.bolao.dto.MatchDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.dto.ResolveSlotRequest;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.services.MatchService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Path("/v1/admin/resolve-slot")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AdminResource {

    @Inject
    MatchService matchService;

    @PATCH
    public Response resolveSlot(@Valid ResolveSlotRequest request) {
        int updatedMatches = matchService.resolveSlot(request.getSlotCode(), request.getFifaCode());
        return Response.ok(java.util.Map.of("updatedMatches", updatedMatches)).build();
    }
}
