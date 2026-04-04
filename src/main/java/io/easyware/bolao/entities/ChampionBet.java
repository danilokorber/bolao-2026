package io.easyware.bolao.entities;

import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "champion_bet",
       uniqueConstraints = {
           @UniqueConstraint(name = "idx_champion_bet_user", columnNames = {"user_id"})
       })
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChampionBet {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "champion_team_id")
    private Team championTeam;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "runner_up_team_id")
    private Team runnerUpTeam;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "semifinalist1_team_id")
    private Team semifinalist1Team;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "semifinalist2_team_id")
    private Team semifinalist2Team;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "semifinalist3_team_id")
    private Team semifinalist3Team;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "semifinalist4_team_id")
    private Team semifinalist4Team;

    @Column(name = "bet_at", nullable = false)
    @Builder.Default
    private LocalDateTime betAt = LocalDateTime.now();

    @Column(name = "bonus_points", nullable = false)
    @Builder.Default
    private Integer bonusPoints = 0;

    /**
     * Calculates points achieved for this champion bet based on actual tournament results.
     *
     * Scoring rules:
     * - Correct champion: 10 points
     * - Correct runner-up: 5 points
     * - Each correct semifinalist: 3 points
     *
     * @param actualChampion the actual tournament champion
     * @param actualRunnerUp the actual runner-up
     * @param actualSemifinalists the actual semifinalists (should be 4 teams)
     * @return the calculated points for this bet
     */
    @Transient
    public Integer calculatePoints(Team actualChampion, Team actualRunnerUp, Team... actualSemifinalists) {
        int points = 0;

        // Check champion prediction
        if (championTeam != null && actualChampion != null &&
            championTeam.getId().equals(actualChampion.getId())) {
            points += 10;
        }

        // Check runner-up prediction
        if (runnerUpTeam != null && actualRunnerUp != null &&
            runnerUpTeam.getId().equals(actualRunnerUp.getId())) {
            points += 5;
        }

        // Check semifinalists
        if (actualSemifinalists != null && actualSemifinalists.length > 0) {
            Team[] predictedSemifinalists = {
                semifinalist1Team, semifinalist2Team, semifinalist3Team, semifinalist4Team
            };

            for (Team predicted : predictedSemifinalists) {
                if (predicted != null) {
                    for (Team actual : actualSemifinalists) {
                        if (actual != null && predicted.getId().equals(actual.getId())) {
                            points += 3;
                            break;
                        }
                    }
                }
            }
        }

        return points;
    }

    /**
     * Gets the stored bonus points or calculates them if tournament results are available.
     *
     * @return the bonus points for this champion bet
     */
    @Transient
    public Integer getCalculatedPoints() {
        return bonusPoints;
    }
}
