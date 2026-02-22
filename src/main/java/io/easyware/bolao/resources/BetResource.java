package io.easyware.bolao.resources;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.services.BetService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.SecurityContext;
import lombok.extern.java.Log;

import java.util.List;
import java.util.UUID;

@Log
@Path("/v1/bets")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BetResource {

    @Inject
    BetService betService;

    @Inject
    SecurityContext securityContext;

    @GET
//    @Authenticated
    public List<BetDTO> getAll() {
//        log.info(securityContext.getUserPrincipal().getName());
        return betService.findAll();
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
    public Response create(BetDTO betDTO) {
        BetDTO created = betService.create(betDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public BetDTO update(@PathParam("id") UUID id, BetDTO betDTO) {
        return betService.update(id, betDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        betService.delete(id);
        return Response.noContent().build();
    }
}
