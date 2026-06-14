package io.easyware.bolao.clients;

import io.easyware.bolao.dto.theoddsapi.TheOddsEvent;
import io.easyware.bolao.dto.theoddsapi.TheOddsOdds;
import io.quarkus.rest.client.reactive.ClientQueryParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

import java.util.List;

/**
 * MicroProfile REST Client for The Odds API (v4).
 *
 * <p>Configuration keys (in application.yml under {@code quarkus.rest-client.the-odds-api}):
 * <ul>
 *   <li>{@code url} — base URL (default {@code https://api.the-odds-api.com})</li>
 *   <li>{@code read-timeout} / {@code connect-timeout}</li>
 * </ul>
 *
 * <p>The API key is injected via the {@code apiKey} query parameter from
 * config property {@code the-odds-api.api-key}.
 *
 * @see <a href="https://the-odds-api.com/liveapi/guides/v4/">The Odds API docs</a>
 */
@RegisterRestClient(configKey = "the-odds-api")
@Produces(MediaType.APPLICATION_JSON)
@ClientQueryParam(name = "apiKey", value = "${the-odds-api.api-key}")
public interface TheOddsApiClient {

    /**
     * Fetches FIFA World Cup events for the {@code soccer_fifa_world_cup} sport key.
     *
     * @return the list of available World Cup events
     */
    @GET
    @Path("/sports/soccer_fifa_world_cup/events")
    List<TheOddsEvent> getEvents();

    /**
     * Fetches bookmaker odds for a specific FIFA World Cup event.
     *
     * @param eventId The Odds API event identifier
     * @return odds data for the provided event with the {@code h2h} market
     */
    @GET
    @Path("/sports/soccer_fifa_world_cup/events/{eventId}/odds")
    @ClientQueryParam(name = "regions", value = "eu")
    @ClientQueryParam(name = "markets", value = "h2h")
    TheOddsOdds getOddsForEvent(@PathParam("eventId") String eventId);
}
