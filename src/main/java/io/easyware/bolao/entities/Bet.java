package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "bet",
       uniqueConstraints = {
           @UniqueConstraint(name = "idx_bet_user_match", columnNames = {"user_id", "match_id"})
       },
       indexes = {
           @Index(name = "idx_bet_user", columnList = "user_id"),
           @Index(name = "idx_bet_match", columnList = "match_id")
       })
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Bet {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "match_id", nullable = false)
    private Match match;

    @Column(name = "home_goals_bet", nullable = false)
    private Integer homeGoalsBet;

    @Column(name = "away_goals_bet", nullable = false)
    private Integer awayGoalsBet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "winner_bet_id")
    private Team winnerBet;

    @Column(name = "points_earned", nullable = false)
    @Builder.Default
    private Integer pointsEarned = 0;

    @Column(name = "bet_at", nullable = false)
    @Builder.Default
    private LocalDateTime betAt = LocalDateTime.now();

    /**
     * Calculates points achieved for this bet based on the actual 90-minute match result,
     * then applies the stage multiplier.
     *
     * Base scoring rules (highest applicable tier wins):
     * <ol>
     *   <li>Exact score: 20 points</li>
     *   <li>Correct goal difference (implies correct winner): 10 points</li>
     *   <li>Correct winner (or draw), wrong margin: 6 points</li>
     *   <li>Inverted exact score (e.g. match 2:0, bet 0:2) — fun factor: 2 points</li>
     *   <li>Wrong prediction: -6 points</li>
     * </ol>
     *
     * Stage multipliers: Group/R32 = 1×, R16 = 1.5×, QF = 2×, SF/3rd/Final = 3×.
     * All base values are even, so multiplied results are always integers.
     *
     * @return the calculated points for this bet (base × stage multiplier)
     */
    @Transient
    public Integer getCalculatedPoints() {
        if (match == null || match.getHomeGoals() == null || match.getAwayGoals() == null) {
            return 0;
        }

        Integer actualHome = match.getHomeGoals();
        Integer actualAway = match.getAwayGoals();
        int actualDiff = actualHome - actualAway;
        int betDiff = homeGoalsBet - awayGoalsBet;

        int basePoints;

        // 1. Exact score
        if (homeGoalsBet.equals(actualHome) && awayGoalsBet.equals(actualAway)) {
            basePoints = 20;
        }
        // 2. Correct goal difference (same team winning by same margin)
        else if (betDiff == actualDiff) {
            basePoints = 10;
        }
        // 3. Correct winner (or correct draw — already handled above since draw diff = 0)
        else if (Integer.compare(homeGoalsBet, awayGoalsBet) == Integer.compare(actualHome, actualAway)) {
            basePoints = 6;
        }
        // 4. Inverted exact score — fun factor (draws naturally excluded: inversion = exact)
        else if (homeGoalsBet.equals(actualAway) && awayGoalsBet.equals(actualHome)) {
            basePoints = 2;
        }
        // 5. Wrong prediction — penalty
        else {
            basePoints = -6;
        }

        return (int) (basePoints * match.getStage().getMultiplier());
    }
}
