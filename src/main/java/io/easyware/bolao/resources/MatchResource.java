package io.easyware.bolao.resources;

import io.easyware.bolao.dto.MatchDTO;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.services.MatchService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Path("/v1/matches")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MatchResource {

    @Inject
    MatchService matchService;

    @GET
    public List<MatchDTO> getAll(@QueryParam("userId") UUID userId) {
        return matchService.findAll(userId);
    }

    @GET
    @Path("/id/{id}")
    public MatchDTO getById(@PathParam("id") UUID id, @QueryParam("userId") UUID userId) {
        return matchService.findById(id, userId);
    }

    @GET
    @Path("/stage/{stage}")
    public List<MatchDTO> getByStage(@PathParam("stage") MatchStage stage, @QueryParam("userId") UUID userId) {
        return matchService.findByStage(stage, userId);
    }

    @GET
    @Path("/status/{status}")
    public List<MatchDTO> getByStatus(@PathParam("status") MatchStatus status, @QueryParam("userId") UUID userId) {
        return matchService.findByStatus(status, userId);
    }

    @GET
    @Path("/team/id/{teamId}")
    public List<MatchDTO> getByTeam(@PathParam("teamId") UUID teamId, @QueryParam("userId") UUID userId) {
        return matchService.findByTeam(teamId, userId);
    }

    @GET
    @Path("/upcoming")
    public List<MatchDTO> getUpcoming(@QueryParam("next") @DefaultValue("10") int next, @QueryParam("userId") UUID userId) {
        return matchService.findUpcoming(next, userId);
    }

    @GET
    @Path("/date-range")
    public List<MatchDTO> getByDateRange(
            @QueryParam("start") String start,
            @QueryParam("end") String end,
            @QueryParam("userId") UUID userId) {
        LocalDateTime startDate = LocalDateTime.parse(start);
        LocalDateTime endDate = LocalDateTime.parse(end);
        return matchService.findByDateRange(startDate, endDate, userId);
    }

    @POST
    public Response create(MatchDTO matchDTO) {
        MatchDTO created = matchService.create(matchDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public MatchDTO update(@PathParam("id") UUID id, MatchDTO matchDTO) {
        return matchService.update(id, matchDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        matchService.delete(id);
        return Response.noContent().build();
    }
}
