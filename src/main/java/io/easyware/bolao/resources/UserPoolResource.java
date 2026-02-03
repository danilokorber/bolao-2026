package io.easyware.bolao.resources;

import io.easyware.bolao.dto.UserPoolDTO;
import io.easyware.bolao.enums.UserPoolStatus;
import io.easyware.bolao.services.UserPoolService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/user-pools")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserPoolResource {

    @Inject
    UserPoolService userPoolService;

    @GET
    public List<UserPoolDTO> getAll() {
        return userPoolService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public UserPoolDTO getById(@PathParam("id") UUID id) {
        return userPoolService.findById(id);
    }

    @GET
    @Path("/user/id/{userId}")
    public List<UserPoolDTO> getByUser(@PathParam("userId") UUID userId) {
        return userPoolService.findByUser(userId);
    }

    @GET
    @Path("/pool/id/{poolId}")
    public List<UserPoolDTO> getByPool(@PathParam("poolId") UUID poolId) {
        return userPoolService.findByPool(poolId);
    }

    @GET
    @Path("/user/id/{userId}/pool/id/{poolId}")
    public UserPoolDTO getByUserAndPool(
            @PathParam("userId") UUID userId,
            @PathParam("poolId") UUID poolId) {
        return userPoolService.findByUserAndPool(userId, poolId);
    }

    @GET
    @Path("/user/id/{userId}/status/{status}")
    public List<UserPoolDTO> getByUserAndStatus(
            @PathParam("userId") UUID userId,
            @PathParam("status") UserPoolStatus status) {
        return userPoolService.findByUserAndStatus(userId, status);
    }

    @GET
    @Path("/pool/id/{poolId}/status/{status}")
    public List<UserPoolDTO> getByPoolAndStatus(
            @PathParam("poolId") UUID poolId,
            @PathParam("status") UserPoolStatus status) {
        return userPoolService.findByPoolAndStatus(poolId, status);
    }

    @GET
    @Path("/pool/id/{poolId}/members/count")
    public long countActiveMembers(@PathParam("poolId") UUID poolId) {
        return userPoolService.countActiveMembers(poolId);
    }

    @POST
    public Response create(UserPoolDTO userPoolDTO) {
        UserPoolDTO created = userPoolService.create(userPoolDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public UserPoolDTO update(@PathParam("id") UUID id, UserPoolDTO userPoolDTO) {
        return userPoolService.update(id, userPoolDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        userPoolService.delete(id);
        return Response.noContent().build();
    }
}
