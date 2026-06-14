package io.easyware.bolao.dto.theoddsapi;

import jakarta.json.bind.annotation.JsonbProperty;
import lombok.*;

/**
 * The Odds API event representation returned by:
 * /v4/sports/soccer_fifa_world_cup/events
 */
@Getter
@Setter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class TheOddsEvent {
    private String id;
    @JsonbProperty("sport_key")
    private String sportKey;
    @JsonbProperty("sport_title")
    private String sportTitle;
    @JsonbProperty("commence_time")
    private String commenceTime;
    @JsonbProperty("home_team")
    private String homeTeam;
    @JsonbProperty("away_team")
    private String awayTeam;
}
