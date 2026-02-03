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
     * Calculates points achieved for this bet based on the actual match result.
     *
     * Scoring rules:
     * - Exact score: 5 points
     * - Correct goal difference: 3 points
     * - Correct winner (or draw): 1 point
     * - For knockout matches that went to penalties: bonus 2 points if winnerBet is correct
     *
     * @return the calculated points for this bet
     */
    @Transient
    public Integer getCalculatedPoints() {
        if (match == null || match.getHomeGoals() == null || match.getAwayGoals() == null) {
            return 0;
        }

        Integer actualHome = match.getHomeGoals();
        Integer actualAway = match.getAwayGoals();
        int points = 0;

        // Check for exact score
        if (homeGoalsBet.equals(actualHome) && awayGoalsBet.equals(actualAway)) {
            points = 5;
        }
        // Check for correct goal difference
        else if ((homeGoalsBet - awayGoalsBet) == (actualHome - actualAway)) {
            points = 3;
        }
        // Check for correct winner or draw
        else {
            int betResult = Integer.compare(homeGoalsBet, awayGoalsBet);
            int actualResult = Integer.compare(actualHome, actualAway);
            if (betResult == actualResult) {
                points = 1;
            }
        }

        // Bonus points for correctly predicting penalty winner in knockout matches
        if (Boolean.TRUE.equals(match.getWentToPenalties()) &&
            winnerBet != null &&
            match.getWinner() != null &&
            winnerBet.getId().equals(match.getWinner().getId())) {
            points += 2;
        }

        return points;
    }
}
