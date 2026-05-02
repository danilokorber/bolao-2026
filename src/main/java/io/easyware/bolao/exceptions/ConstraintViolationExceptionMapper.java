package io.easyware.bolao.exceptions;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

import java.util.List;
import java.util.Map;

@Provider
public class ConstraintViolationExceptionMapper implements ExceptionMapper<ConstraintViolationException> {

    @Override
    public Response toResponse(ConstraintViolationException exception) {
        List<Map<String, String>> violations = exception.getConstraintViolations().stream()
                .map(this::toViolationMap)
                .toList();

        Map<String, Object> body = Map.of(
                "title", "Constraint Violation",
                "status", 400,
                "violations", violations
        );

        return Response.status(Response.Status.BAD_REQUEST)
                .type(MediaType.APPLICATION_JSON)
                .entity(body)
                .build();
    }

    private Map<String, String> toViolationMap(ConstraintViolation<?> violation) {
        String field = extractFieldName(violation.getPropertyPath().toString());
        return Map.of(
                "field", field,
                "message", violation.getMessage()
        );
    }

    private String extractFieldName(String propertyPath) {
        // Property path for JAX-RS params looks like "save.request.fieldName"
        int lastDot = propertyPath.lastIndexOf('.');
        return lastDot >= 0 ? propertyPath.substring(lastDot + 1) : propertyPath;
    }
}
