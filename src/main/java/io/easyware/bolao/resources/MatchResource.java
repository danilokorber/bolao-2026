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
    public List<MatchDTO> getAll() {
        return matchService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public MatchDTO getById(@PathParam("id") UUID id) {
        return matchService.findById(id);
    }

    @GET
    @Path("/stage/{stage}")
    public List<MatchDTO> getByStage(@PathParam("stage") MatchStage stage) {
        return matchService.findByStage(stage);
    }

    @GET
    @Path("/status/{status}")
    public List<MatchDTO> getByStatus(@PathParam("status") MatchStatus status) {
        return matchService.findByStatus(status);
    }

    @GET
    @Path("/team/id/{teamId}")
    public List<MatchDTO> getByTeam(@PathParam("teamId") UUID teamId) {
        return matchService.findByTeam(teamId);
    }

    @GET
    @Path("/upcoming")
    public List<MatchDTO> getUpcoming(@QueryParam("next") @DefaultValue("10") int next) {
        return matchService.findUpcoming(next);
    }

    @GET
    @Path("/date-range")
    public List<MatchDTO> getByDateRange(
            @QueryParam("start") String start,
            @QueryParam("end") String end) {
        LocalDateTime startDate = LocalDateTime.parse(start);
        LocalDateTime endDate = LocalDateTime.parse(end);
        return matchService.findByDateRange(startDate, endDate);
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
