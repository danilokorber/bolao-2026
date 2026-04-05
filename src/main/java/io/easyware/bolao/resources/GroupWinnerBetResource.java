package io.easyware.bolao.resources;

import io.easyware.bolao.dto.GroupWinnerBetDTO;
import io.easyware.bolao.dto.GroupWinnerBetRequestDTO;
import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.services.GroupWinnerBetService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/group-winner-bets")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class GroupWinnerBetResource {

    @Inject
    GroupWinnerBetService groupWinnerBetService;

    @GET
    public List<GroupWinnerBetDTO> getAll() {
        return groupWinnerBetService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public GroupWinnerBetDTO getById(@PathParam("id") UUID id) {
        return groupWinnerBetService.findById(id);
    }

    @GET
    @Path("/user/id/{userId}")
    public List<GroupWinnerBetDTO> getByUser(@PathParam("userId") UUID userId) {
        return groupWinnerBetService.findByUser(userId);
    }

    @GET
    @Path("/group/{groupName}")
    public List<GroupWinnerBetDTO> getByGroup(@PathParam("groupName") GroupName groupName) {
        return groupWinnerBetService.findByGroup(groupName);
    }

    @GET
    @Path("/user/id/{userId}/group/{groupName}")
    public GroupWinnerBetDTO getByUserAndGroup(
            @PathParam("userId") UUID userId,
            @PathParam("groupName") GroupName groupName) {
        return groupWinnerBetService.findByUserAndGroup(userId, groupName);
    }

    @POST
    public Response save(GroupWinnerBetRequestDTO request) {
        GroupWinnerBetDTO saved = groupWinnerBetService.save(request);
        return Response.ok(saved).build();
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        groupWinnerBetService.delete(id);
        return Response.noContent().build();
    }
}
