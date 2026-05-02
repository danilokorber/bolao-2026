package io.easyware.bolao.resources;

import io.easyware.bolao.dto.ChampionBetDTO;
import io.easyware.bolao.dto.ChampionBetRequestDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.services.ChampionBetService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Path("/v1/champion-bets")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class ChampionBetResource {

    @Inject
    ChampionBetService championBetService;

    @GET
    public PagedResponse<ChampionBetDTO> getAll(
            @QueryParam("page") @DefaultValue("0") int page,
            @QueryParam("size") @DefaultValue("50") int size) {
        return championBetService.findAll(page, size);
    }

    @GET
    @Path("/id/{id}")
    public ChampionBetDTO getById(@PathParam("id") UUID id) {
        return championBetService.findById(id);
    }

    @GET
    @Path("/user/id/{userId}")
    public ChampionBetDTO getByUser(@PathParam("userId") UUID userId) {
        return championBetService.findByUser(userId);
    }

    @GET
    @Path("/stats/champion/id/{teamId}")
    public long countByChampion(@PathParam("teamId") UUID teamId) {
        return championBetService.countByChampionTeam(teamId);
    }

    @GET
    @Path("/stats/runner-up/id/{teamId}")
    public long countByRunnerUp(@PathParam("teamId") UUID teamId) {
        return championBetService.countByRunnerUpTeam(teamId);
    }

    @GET
    @Path("/deadline")
    public Response getDeadline() {
        return championBetService.getDeadline()
                .map(deadline -> Response.ok(Map.of("deadline", deadline)).build())
                .orElse(Response.ok(Map.of()).build());
    }

    @POST
    public Response save(@Valid ChampionBetRequestDTO request) {
        ChampionBetDTO saved = championBetService.save(request);
        return Response.ok(saved).build();
    }

    @DELETE
    @Path("/id/{id}")
    @RolesAllowed("admin")
    public Response delete(@PathParam("id") UUID id) {
        championBetService.delete(id);
        return Response.noContent().build();
    }
}
