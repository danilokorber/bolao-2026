package io.easyware.bolao.resources;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.dto.BetRequestDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.services.BetService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.SecurityContext;

import java.util.List;
import java.util.UUID;

@Path("/v1/bets")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class BetResource {

    @Inject
    BetService betService;

    @Inject
    SecurityContext securityContext;

    @GET
    public PagedResponse<BetDTO> getAll(
            @QueryParam("page") @DefaultValue("0") int page,
            @QueryParam("size") @DefaultValue("10000") int size) {
        String sub = securityContext.getUserPrincipal().getName();
        return betService.findAll(page, size, sub);
    }

    @GET
    @Path("/id/{id}")
    public BetDTO getById(@PathParam("id") UUID id) {
        return betService.findById(id);
    }

    @GET
    @Path("/user/id/{userId}")
    public List<BetDTO> getByUser(@PathParam("userId") UUID userId) {
        return betService.findByUser(userId);
    }

    @GET
    @Path("/match/id/{matchId}")
    public List<BetDTO> getByMatch(@PathParam("matchId") UUID matchId) {
        return betService.findByMatch(matchId);
    }

    @GET
    @Path("/user/id/{userId}/match/id/{matchId}")
    public BetDTO getByUserAndMatch(
            @PathParam("userId") UUID userId,
            @PathParam("matchId") UUID matchId) {
        return betService.findByUserAndMatch(userId, matchId);
    }

    @GET
    @Path("/leaderboard")
    public List<BetDTO> getLeaderboard(@QueryParam("limit") @DefaultValue("10") int limit) {
        return betService.findTopScorers(limit);
    }

    @GET
    @Path("/user/id/{userId}/total-points")
    public long getTotalPoints(@PathParam("userId") UUID userId) {
        return betService.getTotalPointsByUser(userId);
    }

    @POST
    public Response save(@Valid BetRequestDTO request) {
        BetDTO saved = betService.save(request);
        return Response.ok(saved).build();
    }

    @DELETE
    @Path("/id/{id}")
    @RolesAllowed("admin")
    public Response delete(@PathParam("id") UUID id) {
        betService.delete(id);
        return Response.noContent().build();
    }
}
