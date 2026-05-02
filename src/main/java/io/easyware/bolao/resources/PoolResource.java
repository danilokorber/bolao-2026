package io.easyware.bolao.resources;

import io.easyware.bolao.dto.PoolDTO;
import io.easyware.bolao.services.PoolService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/pools")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PoolResource {

    @Inject
    PoolService poolService;

    @GET
    public List<PoolDTO> getAll() {
        return poolService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public PoolDTO getById(@PathParam("id") UUID id) {
        return poolService.findById(id);
    }

    @GET
    @Path("/invite-code/{inviteCode}")
    public PoolDTO getByInviteCode(@PathParam("inviteCode") String inviteCode) {
        return poolService.findByInviteCode(inviteCode);
    }

    @GET
    @Path("/active")
    public List<PoolDTO> getActivePools() {
        return poolService.findActivePools();
    }

    @GET
    @Path("/recent")
    public List<PoolDTO> getRecent() {
        return poolService.findByCreatedAtDesc();
    }

    @POST
    public Response create(@Valid PoolDTO poolDTO) {
        PoolDTO created = poolService.create(poolDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public PoolDTO update(@PathParam("id") UUID id, @Valid PoolDTO poolDTO) {
        return poolService.update(id, poolDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        poolService.delete(id);
        return Response.noContent().build();
    }
}
