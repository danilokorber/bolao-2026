package io.easyware.bolao.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

class GroupWinnerBetScoringTest {

    private Team teamA, teamB, teamC, teamD;

    @BeforeEach
    void setUp() {
        teamA = Team.builder().id(UUID.randomUUID()).build();
        teamB = Team.builder().id(UUID.randomUUID()).build();
        teamC = Team.builder().id(UUID.randomUUID()).build();
        teamD = Team.builder().id(UUID.randomUUID()).build();
    }

    private GroupWinnerBet bet(Team first, Team second) {
        return GroupWinnerBet.builder()
                .firstPlaceTeam(first)
                .secondPlaceTeam(second)
                .build();
    }

    @Test
    @DisplayName("Both correct → 10 points (5 + 3 + 2 bonus)")
    void bothCorrect() {
        GroupWinnerBet b = bet(teamA, teamB);
        assertThat(b.calculatePoints(teamA, teamB)).isEqualTo(10);
    }

    @Test
    @DisplayName("Only 1st place correct → 5 points")
    void onlyFirstCorrect() {
        GroupWinnerBet b = bet(teamA, teamB);
        assertThat(b.calculatePoints(teamA, teamC)).isEqualTo(5);
    }

    @Test
    @DisplayName("Only 2nd place correct → 3 points")
    void onlySecondCorrect() {
        GroupWinnerBet b = bet(teamA, teamB);
        assertThat(b.calculatePoints(teamC, teamB)).isEqualTo(3);
    }

    @Test
    @DisplayName("Both wrong → 0 points")
    void bothWrong() {
        GroupWinnerBet b = bet(teamA, teamB);
        assertThat(b.calculatePoints(teamC, teamD)).isEqualTo(0);
    }

    @Test
    @DisplayName("Swapped predictions → 0 points (wrong positions)")
    void swappedPredictions() {
        GroupWinnerBet b = bet(teamA, teamB);
        assertThat(b.calculatePoints(teamB, teamA)).isEqualTo(0);
    }

    @Test
    @DisplayName("Null actual teams → 0 points")
    void nullActualTeams() {
        GroupWinnerBet b = bet(teamA, teamB);
        assertThat(b.calculatePoints(null, null)).isEqualTo(0);
    }

    @Test
    @DisplayName("Null predicted teams → 0 points")
    void nullPredictedTeams() {
        GroupWinnerBet b = bet(null, null);
        assertThat(b.calculatePoints(teamA, teamB)).isEqualTo(0);
    }
}
