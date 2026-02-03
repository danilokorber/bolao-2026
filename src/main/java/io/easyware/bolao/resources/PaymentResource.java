package io.easyware.bolao.resources;

import io.easyware.bolao.dto.PaymentDTO;
import io.easyware.bolao.enums.PaymentStatus;
import io.easyware.bolao.services.PaymentService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;
import java.util.UUID;

@Path("/v1/payments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PaymentResource {

    @Inject
    PaymentService paymentService;

    @GET
    public List<PaymentDTO> getAll() {
        return paymentService.findAll();
    }

    @GET
    @Path("/id/{id}")
    public PaymentDTO getById(@PathParam("id") UUID id) {
        return paymentService.findById(id);
    }

    @GET
    @Path("/user/id/{userId}")
    public List<PaymentDTO> getByUser(@PathParam("userId") UUID userId) {
        return paymentService.findByUser(userId);
    }

    @GET
    @Path("/pool/id/{poolId}")
    public List<PaymentDTO> getByPool(@PathParam("poolId") UUID poolId) {
        return paymentService.findByPool(poolId);
    }

    @GET
    @Path("/user/id/{userId}/pool/id/{poolId}")
    public List<PaymentDTO> getByUserAndPool(
            @PathParam("userId") UUID userId,
            @PathParam("poolId") UUID poolId) {
        return paymentService.findByUserAndPool(userId, poolId);
    }

    @GET
    @Path("/status/{status}")
    public List<PaymentDTO> getByStatus(@PathParam("status") PaymentStatus status) {
        return paymentService.findByStatus(status);
    }

    @GET
    @Path("/transaction/{transactionId}")
    public PaymentDTO getByTransactionId(@PathParam("transactionId") String transactionId) {
        return paymentService.findByTransactionId(transactionId);
    }

    @GET
    @Path("/pool/id/{poolId}/pending")
    public List<PaymentDTO> getPendingByPool(@PathParam("poolId") UUID poolId) {
        return paymentService.findPendingByPool(poolId);
    }

    @POST
    public Response create(PaymentDTO paymentDTO) {
        PaymentDTO created = paymentService.create(paymentDTO);
        return Response.status(Response.Status.CREATED).entity(created).build();
    }

    @PUT
    @Path("/id/{id}")
    public PaymentDTO update(@PathParam("id") UUID id, PaymentDTO paymentDTO) {
        return paymentService.update(id, paymentDTO);
    }

    @DELETE
    @Path("/id/{id}")
    public Response delete(@PathParam("id") UUID id) {
        paymentService.delete(id);
        return Response.noContent().build();
    }
}
