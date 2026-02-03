package io.easyware.bolao.resources;

import io.easyware.bolao.dto.ChampionBetDTO;
import io.easyware.bolao.services.ChampionBetService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/champion-bets")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ChampionBetResource {

    @Inject
    ChampionBetService championBetService;

    @GET
    public List<ChampionBetDTO> getAll() {
        return championBetService.findAll();
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

    @POST
    public Response create(ChampionBetDTO championBetDTO) {
        ChampionBetDTO created = championBetService.create(championBetDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public ChampionBetDTO update(@PathParam("id") UUID id, ChampionBetDTO championBetDTO) {
        return championBetService.update(id, championBetDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        championBetService.delete(id);
        return Response.noContent().build();
    }
}
