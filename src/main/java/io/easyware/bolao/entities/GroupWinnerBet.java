package io.easyware.bolao.entities;

import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "group_winner_bet",
       uniqueConstraints = {
           @UniqueConstraint(name = "idx_group_winner_bet_user_group", columnNames = {"user_id", "group_name"})
       },
       indexes = {
           @Index(name = "idx_group_winner_bet_user", columnList = "user_id"),
           @Index(name = "idx_group_winner_bet_group", columnList = "group_name")
       })
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupWinnerBet {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Enumerated(EnumType.STRING)
    @Column(name = "group_name", nullable = false, length = 10)
    private GroupName groupName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "first_place_team_id", nullable = false)
    private Team firstPlaceTeam;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "second_place_team_id", nullable = false)
    private Team secondPlaceTeam;

    @Column(name = "bet_at", nullable = false)
    @Builder.Default
    private LocalDateTime betAt = LocalDateTime.now();

    @Column(name = "points_earned", nullable = false)
    @Builder.Default
    private Integer pointsEarned = 0;

    /**
     * Calculates points achieved for this group winner bet based on actual group standings.
     *
     * Scoring rules:
     * - Correct 1st place: 5 points
     * - Correct 2nd place: 3 points
     * - Both positions correct: 10 points (bonus)
     *
     * @param actualFirstPlace the actual first place team
     * @param actualSecondPlace the actual second place team
     * @return the calculated points for this bet
     */
    @Transient
    public Integer calculatePoints(Team actualFirstPlace, Team actualSecondPlace) {
        int points = 0;
        boolean firstCorrect = false;
        boolean secondCorrect = false;

        // Check first place prediction
        if (firstPlaceTeam != null && actualFirstPlace != null &&
            firstPlaceTeam.getId().equals(actualFirstPlace.getId())) {
            points += 5;
            firstCorrect = true;
        }

        // Check second place prediction
        if (secondPlaceTeam != null && actualSecondPlace != null &&
            secondPlaceTeam.getId().equals(actualSecondPlace.getId())) {
            points += 3;
            secondCorrect = true;
        }

        // Bonus for getting both positions correct
        if (firstCorrect && secondCorrect) {
            points += 2; // Total: 10 points (5 + 3 + 2 bonus)
        }

        return points;
    }

    /**
     * Gets the stored points earned or returns 0 if not yet calculated.
     *
     * @return the points earned for this group winner bet
     */
    @Transient
    public Integer getCalculatedPoints() {
        return pointsEarned;
    }
}
