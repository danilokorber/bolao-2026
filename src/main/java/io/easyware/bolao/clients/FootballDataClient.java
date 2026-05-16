package io.easyware.bolao.clients;

import io.easyware.bolao.dto.footballdata.FootballDataResponse;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.annotation.ClientHeaderParam;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

/**
 * MicroProfile REST Client for the football-data.org API (v4).
 *
 * <p>Configuration keys (in application.yml under {@code quarkus.rest-client.football-data}):
 * <ul>
 *   <li>{@code url} — base URL (default {@code https://api.football-data.org/v4})</li>
 *   <li>{@code read-timeout} / {@code connect-timeout}</li>
 * </ul>
 *
 * <p>The API key is injected via the {@code X-Auth-Token} header from the
 * config property {@code football-data.api-key}.
 *
 * @see <a href="https://docs.football-data.org/general/v4/index.html">football-data.org API docs</a>
 */
@RegisterRestClient(configKey = "football-data")
@Produces(MediaType.APPLICATION_JSON)
@ClientHeaderParam(name = "X-Auth-Token", value = "${football-data.api-key}")
public interface FootballDataClient {

    /**
     * Fetches all matches for the FIFA World Cup 2026 (competition ID 2000).
     * Returns statuses, scores, and metadata for every match in one call.
     * Free tier: 10 requests / minute.
     *
     * @return the full competition matches response
     */
    @GET
    @Path("/competitions/2000/matches")
    FootballDataResponse getWorldCupMatches();
}
