package io.easyware.bolao.resources;

import io.easyware.bolao.dto.TeamDTO;
import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.services.TeamService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.RolesAllowed;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/teams")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class TeamResource {

    @Inject
    TeamService teamService;

    @GET
    public List<TeamDTO> getAll() {
        return teamService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public TeamDTO getById(@PathParam("id") UUID id) {
        return teamService.findById(id);
    }

    @GET
    @Path("/fifa-code/{fifaCode}")
    public TeamDTO getByFifaCode(@PathParam("fifaCode") String fifaCode) {
        return teamService.findByFifaCode(fifaCode);
    }

    @GET
    @Path("/group/{groupName}")
    public List<TeamDTO> getByGroup(@PathParam("groupName") GroupName groupName) {
        return teamService.findByGroup(groupName);
    }

    @POST
    @RolesAllowed("admin")
    public Response create(TeamDTO teamDTO) {
        TeamDTO created = teamService.create(teamDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    @RolesAllowed("admin")
    public TeamDTO update(@PathParam("id") UUID id, TeamDTO teamDTO) {
        return teamService.update(id, teamDTO);
    }

    @DELETE
    @Path("/id/{id}")
    @RolesAllowed("admin")
    public Response delete(@PathParam("id") UUID id) {
        teamService.delete(id);
        return Response.noContent().build();
    }
}
