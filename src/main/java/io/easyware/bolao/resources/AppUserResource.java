package io.easyware.bolao.resources;

import io.easyware.bolao.dto.AppUserDTO;
import io.easyware.bolao.services.AppUserService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

/**
 * REST resource for managing application users.
 *
 * <p>Base path: {@code /v1/users}
 */
@Path("/v1/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AppUserResource {

    @Inject
    AppUserService appUserService;

    /**
     * Lists all registered users.
     *
     * @return 200 with the list of users (may be empty)
     */
    @GET
    public List<AppUserDTO> getAll() {
        return appUserService.findAll();
    }

    /**
     * Finds a user by internal UUID.
     *
     * @param id the user's UUID
     * @return 200 with the user
     * @throws NotFoundException 404 if no user exists with the given id
     */
    @GET
    @Path("/id/{id}")
    public AppUserDTO getById(@PathParam("id") UUID id) {
        return appUserService.findById(id);
    }

    /**
     * Finds a user by Keycloak subject identifier.
     *
     * @param keycloakId the Keycloak subject id
     * @return 200 with the user
     * @throws NotFoundException 404 if no user exists with the given keycloakId
     */
    @GET
    @Path("/keycloak/{keycloakId}")
    public AppUserDTO getByKeycloakId(@PathParam("keycloakId") String keycloakId) {
        return appUserService.findByKeycloakId(keycloakId);
    }

    /**
     * Finds a user by email address.
     *
     * @param email the user's email
     * @return 200 with the user
     * @throws NotFoundException 404 if no user exists with the given email
     */
    @GET
    @Path("/email/{email}")
    public AppUserDTO getByEmail(@PathParam("email") String email) {
        return appUserService.findByEmail(email);
    }

    /**
     * Lists all active users.
     *
     * @return 200 with the list of active users (may be empty)
     */
    @GET
    @Path("/active")
    public List<AppUserDTO> getActiveUsers() {
        return appUserService.findActiveUsers();
    }

    /**
     * Registers a user or returns the existing one.
     *
     * <p>If a user with the supplied {@code keycloakId} already exists, the
     * existing record is returned with <strong>200 OK</strong>. Otherwise a
     * new user is created and returned with <strong>201 Created</strong>.
     *
     * @param userDTO the user data; {@code keycloakId}, {@code name}, and
     *                {@code email} are required
     * @return 201 with the newly created user, or 200 with the existing user
     * @throws BadRequestException 400 if keycloakId, name, or email is missing/blank
     */
    @POST
    public Response create(AppUserDTO userDTO) {
        AppUserService.CreateResult result = appUserService.findOrCreate(userDTO);
        Response.Status status = result.created()
                ? Response.Status.CREATED
                : Response.Status.OK;
        return Response.status(status).entity(result.user()).build();
    }

    /**
     * Updates a user's mutable fields (name, email, active).
     *
     * @param id      the user's UUID
     * @param userDTO the new field values
     * @return 200 with the updated user
     * @throws NotFoundException 404 if no user exists with the given id
     */
    @PUT
    @Path("/id/{id}")
    public AppUserDTO update(@PathParam("id") UUID id, AppUserDTO userDTO) {
        return appUserService.update(id, userDTO);
    }

    /**
     * Deletes a user by UUID.
     *
     * @param id the user's UUID
     * @return 204 No Content on success
     * @throws NotFoundException 404 if no user exists with the given id
     */
    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        appUserService.delete(id);
        return Response.noContent().build();
    }
}
