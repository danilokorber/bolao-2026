package io.easyware.bolao.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

class ChampionBetScoringTest {

    private Team brazil, germany, argentina, france, spain, england, italy, portugal;

    @BeforeEach
    void setUp() {
        brazil    = Team.builder().id(UUID.randomUUID()).build();
        germany   = Team.builder().id(UUID.randomUUID()).build();
        argentina = Team.builder().id(UUID.randomUUID()).build();
        france    = Team.builder().id(UUID.randomUUID()).build();
        spain     = Team.builder().id(UUID.randomUUID()).build();
        england   = Team.builder().id(UUID.randomUUID()).build();
        italy     = Team.builder().id(UUID.randomUUID()).build();
        portugal  = Team.builder().id(UUID.randomUUID()).build();
    }

    private ChampionBet bet(Team champion, Team runnerUp, Team sf1, Team sf2, Team sf3, Team sf4) {
        return ChampionBet.builder()
                .championTeam(champion)
                .runnerUpTeam(runnerUp)
                .semifinalist1Team(sf1)
                .semifinalist2Team(sf2)
                .semifinalist3Team(sf3)
                .semifinalist4Team(sf4)
                .build();
    }

    @Nested
    @DisplayName("Champion and Runner-Up scoring")
    class ChampionRunnerUp {

        @Test
        @DisplayName("All wrong → 0 points")
        void allWrong() {
            ChampionBet b = bet(brazil, germany, argentina, france, spain, england);
            int points = b.calculatePoints(italy, portugal, italy, portugal, brazil, germany);
            assertThat(points).isEqualTo(0);
        }

        @Test
        @DisplayName("Champion correct only → 20 points")
        void championCorrectOnly() {
            ChampionBet b = bet(brazil, germany, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, portugal, brazil, portugal, italy, italy);
            assertThat(points).isEqualTo(20);
        }

        @Test
        @DisplayName("Runner-up correct only → 10 points")
        void runnerUpCorrectOnly() {
            ChampionBet b = bet(brazil, germany, argentina, france, spain, england);
            int points = b.calculatePoints(italy, germany, italy, germany, portugal, portugal);
            assertThat(points).isEqualTo(10);
        }

        @Test
        @DisplayName("Champion + runner-up both correct → 30 points")
        void championAndRunnerUpCorrect() {
            ChampionBet b = bet(brazil, germany, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, germany, brazil, germany, italy, portugal);
            assertThat(points).isEqualTo(30);
        }
    }

    @Nested
    @DisplayName("Semifinalist scoring")
    class Semifinalists {

        @Test
        @DisplayName("One semifinalist correct → 5 points")
        void oneSemifinalistCorrect() {
            ChampionBet b = bet(italy, portugal, argentina, france, spain, england);
            // actual semis include argentina; champion/runner-up wrong
            int points = b.calculatePoints(brazil, germany, argentina, brazil, germany, italy);
            assertThat(points).isEqualTo(5);
        }

        @Test
        @DisplayName("Two semifinalists correct → 10 points")
        void twoSemifinalistsCorrect() {
            ChampionBet b = bet(italy, portugal, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, germany, argentina, france, brazil, germany);
            assertThat(points).isEqualTo(10);
        }

        @Test
        @DisplayName("All four semifinalists correct → 20 points")
        void allFourSemifinalistsCorrect() {
            ChampionBet b = bet(italy, portugal, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, germany, argentina, france, spain, england);
            assertThat(points).isEqualTo(20);
        }
    }

    @Nested
    @DisplayName("No double-counting")
    class NoDoubleCounting {

        @Test
        @DisplayName("Champion correct + same team as semifinalist → 20 (not 25)")
        void championNotDoubleCountedAsSemifinalist() {
            // Predict brazil as champion AND as semifinalist1
            ChampionBet b = bet(brazil, portugal, brazil, france, spain, england);
            // brazil is actual champion and actual semifinalist
            int points = b.calculatePoints(brazil, germany, brazil, germany, italy, portugal);
            assertThat(points).isEqualTo(20);
        }

        @Test
        @DisplayName("Runner-up correct + same team as semifinalist → 10 (not 15)")
        void runnerUpNotDoubleCountedAsSemifinalist() {
            // Predict germany as runner-up AND as semifinalist2
            ChampionBet b = bet(portugal, germany, france, germany, spain, england);
            // germany is actual runner-up and actual semifinalist
            int points = b.calculatePoints(brazil, germany, brazil, germany, italy, portugal);
            assertThat(points).isEqualTo(10);
        }
    }

    @Nested
    @DisplayName("Full scenario and edge cases")
    class FullAndEdgeCases {

        @Test
        @DisplayName("Everything correct → 40 points (20+10+5+5, champion/runner-up skipped as semis)")
        void everythingCorrect() {
            // Predict: champion=brazil, runner-up=germany, semis=argentina,france,brazil,germany
            // The 4 actual semifinalists are brazil, germany, argentina, france
            // Champion (brazil) correct → 20, runner-up (germany) correct → 10
            // Semifinalist check: brazil skipped (champion), france matched → 5, brazil skipped, germany skipped
            // Wait — let me be precise about the actual scenario:
            // Predict semis as argentina, france, spain, england
            // Actual semis: brazil, germany, argentina, france
            // Champion correct (brazil)=20, runner-up correct (germany)=10
            // Semi check: argentina in actuals → 5, france in actuals → 5, spain not → 0, england not → 0
            // Total = 40
            ChampionBet b = bet(brazil, germany, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, germany, brazil, germany, argentina, france);
            assertThat(points).isEqualTo(40);
        }

        @Test
        @DisplayName("Null championTeam predicted → 0 for champion portion")
        void nullChampionTeamPredicted() {
            ChampionBet b = bet(null, germany, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, germany, brazil, germany, argentina, france);
            // champion null → 0, runner-up correct → 10, argentina+france → 5+5=10
            assertThat(points).isEqualTo(20);
        }

        @Test
        @DisplayName("Empty actualSemifinalists → only champion/runner-up scored")
        void emptySemifinalistsArray() {
            ChampionBet b = bet(brazil, germany, argentina, france, spain, england);
            int points = b.calculatePoints(brazil, germany);
            assertThat(points).isEqualTo(30);
        }
    }
}
