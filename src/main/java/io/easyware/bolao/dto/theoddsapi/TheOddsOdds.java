package io.easyware.bolao.dto.theoddsapi;

import jakarta.json.bind.annotation.JsonbProperty;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

/**
 * The Odds API odds representation returned by:
 * /v4/sports/soccer_fifa_world_cup/events/{eventId}/odds
 */
@Getter
@Setter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class TheOddsOdds {
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
    private List<Bookmaker> bookmakers;

    public Double getAverageHome() {
        return averagePriceByOutcomeName(homeTeam);
    }

    public Double getAverageAway() {
        return averagePriceByOutcomeName(awayTeam);
    }

    public Double getAvarageDraw() {
        return averagePriceByOutcomeName("Draw");
    }

    public Double getAverageDraw() {
        return getAvarageDraw();
    }

    private Double averagePriceByOutcomeName(String outcomeName) {
        if (outcomeName == null || bookmakers == null || bookmakers.isEmpty()) {
            return null;
        }

        List<Double> prices = new ArrayList<>();
        for (Bookmaker bookmaker : bookmakers) {
            if (bookmaker == null || bookmaker.getMarkets() == null) {
                continue;
            }
            for (Market market : bookmaker.getMarkets()) {
                if (market == null || market.getOutcomes() == null) {
                    continue;
                }
                for (Outcome outcome : market.getOutcomes()) {
                    if (outcome == null || outcome.getPrice() == null) {
                        continue;
                    }
                    if (outcomeName.equalsIgnoreCase(outcome.getName())) {
                        prices.add(outcome.getPrice());
                    }
                }
            }
        }

        if (prices.isEmpty()) {
            return null;
        }

        return prices.stream()
                .mapToDouble(Double::doubleValue)
                .average()
                .orElse(0D);
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Bookmaker {
        private String key;
        private String title;
        private List<Market> markets;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Market {
        private String key;
        @JsonbProperty("last_update")
        private String lastUpdate;
        private List<Outcome> outcomes;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Outcome {
        private String name;
        private Double price;
    }
}
