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
public interface FootballDataClient {

    /**
     * Fetches all matches for the FIFA World Cup (competition code WC / id 2000).
     * Free tier: 10 requests / minute.
     */
    @GET
    @Path("/competitions/WC/matches")
    @ClientHeaderParam(name = "X-Auth-Token", value = "${football-data.api-key}")
    FootballDataResponse getWorldCupMatches();
}
