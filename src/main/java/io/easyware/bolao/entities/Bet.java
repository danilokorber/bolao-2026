package io.easyware.bolao.entities;

import io.easyware.bolao.enums.ScoreTier;
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

    @Enumerated(EnumType.STRING)
    @Column(name = "score_tier", length = 10)
    private ScoreTier scoreTier;

    @Column(name = "bet_at", nullable = false)
    @Builder.Default
    private LocalDateTime betAt = LocalDateTime.now();

    /**
     * Calculates the score tier for this bet based on the actual final match result.
     * For knockout matches this is the score after extra time; penalty shootouts are
     * not counted (the pre-shootout score is used).
     *
     * @return the tier, or null if match result is not yet available
     */
    @Transient
    public ScoreTier getCalculatedScoreTier() {
        if (match == null || match.getHomeGoals() == null || match.getAwayGoals() == null) {
            return null;
        }

        Integer actualHome = match.getHomeGoals();
        Integer actualAway = match.getAwayGoals();
        int actualDiff = actualHome - actualAway;
        int betDiff = homeGoalsBet - awayGoalsBet;

        if (homeGoalsBet.equals(actualHome) && awayGoalsBet.equals(actualAway)) {
            return ScoreTier.EXACT;
        }
        if (betDiff == actualDiff) {
            return ScoreTier.DIFF;
        }
        if (Integer.compare(homeGoalsBet, awayGoalsBet) == Integer.compare(actualHome, actualAway)) {
            return ScoreTier.WINNER;
        }
        if (homeGoalsBet.equals(actualAway) && awayGoalsBet.equals(actualHome)) {
            return ScoreTier.INVERTED;
        }
        return ScoreTier.WRONG;
    }

    /**
     * Calculates points achieved for this bet based on the actual final match result
     * (including extra time for knockout matches; penalty shootouts are not counted),
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
        ScoreTier tier = getCalculatedScoreTier();
        if (tier == null) {
            return 0;
        }

        int basePoints = switch (tier) {
            case EXACT -> 20;
            case DIFF -> 10;
            case WINNER -> 6;
            case INVERTED -> 2;
            case WRONG -> -6;
        };

        return (int) (basePoints * match.getStage().getMultiplier());
    }
}
