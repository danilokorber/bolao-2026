package io.easyware.bolao.resources;

import io.easyware.bolao.dto.AppUserDTO;
import io.easyware.bolao.services.AppUserService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AppUserResource {

    @Inject
    AppUserService appUserService;

    @GET
    public List<AppUserDTO> getAll() {
        return appUserService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public AppUserDTO getById(@PathParam("id") UUID id) {
        return appUserService.findById(id);
    }

    @GET
    @Path("/keycloak/{keycloakId}")
    public AppUserDTO getByKeycloakId(@PathParam("keycloakId") String keycloakId) {
        return appUserService.findByKeycloakId(keycloakId);
    }

    @GET
    @Path("/email/{email}")
    public AppUserDTO getByEmail(@PathParam("email") String email) {
        return appUserService.findByEmail(email);
    }

    @GET
    @Path("/active")
    public List<AppUserDTO> getActiveUsers() {
        return appUserService.findActiveUsers();
    }

    @POST
    public Response create(AppUserDTO userDTO) {
        AppUserDTO created = appUserService.create(userDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public AppUserDTO update(@PathParam("id") UUID id, AppUserDTO userDTO) {
        return appUserService.update(id, userDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        appUserService.delete(id);
        return Response.noContent().build();
    }
}
