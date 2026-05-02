package io.easyware.bolao.entities;

import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.ScoreTier;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Bet scoring logic")
class BetScoringTest {

    private static Bet buildBet(Integer homeBet, Integer awayBet, Integer actualHome, Integer actualAway, MatchStage stage) {
        Match match = Match.builder()
                .homeGoals(actualHome)
                .awayGoals(actualAway)
                .stage(stage)
                .build();
        return Bet.builder()
                .match(match)
                .homeGoalsBet(homeBet)
                .awayGoalsBet(awayBet)
                .build();
    }

    private static Bet buildBet(Integer homeBet, Integer awayBet, Integer actualHome, Integer actualAway) {
        return buildBet(homeBet, awayBet, actualHome, actualAway, MatchStage.GROUP_A);
    }

    // ─── Score Tier Tests ────────────────────────────────────────────────

    @Nested
    @DisplayName("getCalculatedScoreTier()")
    class ScoreTierTests {

        @Nested
        @DisplayName("EXACT — bet matches actual score exactly")
        class ExactTests {

            @ParameterizedTest(name = "bet {0}-{1}, actual {0}-{1} → EXACT")
            @CsvSource({
                "2, 1",
                "0, 0",
                "3, 3",
                "5, 0",
            })
            void exactScore(int home, int away) {
                Bet bet = buildBet(home, away, home, away);
                assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.EXACT);
            }
        }

        @Nested
        @DisplayName("DIFF — correct goal difference but not exact")
        class DiffTests {

            @ParameterizedTest(name = "bet {0}-{1}, actual {2}-{3} → DIFF")
            @CsvSource({
                "2, 0, 3, 1",   // diff=+2
                "1, 1, 0, 0",   // diff=0, both draws but different scores
                "3, 1, 2, 0",   // diff=+2
                "0, 2, 1, 3",   // diff=-2
            })
            void correctDifference(int homeBet, int awayBet, int actualHome, int actualAway) {
                Bet bet = buildBet(homeBet, awayBet, actualHome, actualAway);
                assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.DIFF);
            }

            @Test
            @DisplayName("bet 1-1, actual 2-2 → DIFF (draw diff=0, not WINNER)")
            void drawDiffIsNotWinner() {
                Bet bet = buildBet(1, 1, 2, 2);
                assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.DIFF);
            }
        }

        @Nested
        @DisplayName("WINNER — correct winner but wrong margin")
        class WinnerTests {

            @ParameterizedTest(name = "bet {0}-{1}, actual {2}-{3} → WINNER")
            @CsvSource({
                "3, 0, 1, 0",   // home wins, wrong margin
                "0, 3, 0, 1",   // away wins, wrong margin
                "4, 1, 2, 0",   // home wins, different diff
                "1, 5, 0, 2",   // away wins, different diff
            })
            void correctWinner(int homeBet, int awayBet, int actualHome, int actualAway) {
                Bet bet = buildBet(homeBet, awayBet, actualHome, actualAway);
                assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.WINNER);
            }
        }

        @Nested
        @DisplayName("INVERTED — exact score but swapped")
        class InvertedTests {

            @ParameterizedTest(name = "bet {0}-{1}, actual {2}-{3} → INVERTED")
            @CsvSource({
                "0, 2, 2, 0",
                "1, 3, 3, 1",
                "0, 1, 1, 0",
            })
            void invertedScore(int homeBet, int awayBet, int actualHome, int actualAway) {
                Bet bet = buildBet(homeBet, awayBet, actualHome, actualAway);
                assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.INVERTED);
            }
        }

        @Nested
        @DisplayName("WRONG — no matching criterion")
        class WrongTests {

            @ParameterizedTest(name = "bet {0}-{1}, actual {2}-{3} → WRONG")
            @CsvSource({
                "2, 0, 0, 1",   // bet home win, actual away win
                "0, 0, 2, 1",   // bet draw, actual home win
                "3, 1, 0, 2",   // bet home win, actual away win
                "1, 0, 0, 3",   // bet home win, actual away win (not inverted)
            })
            void wrongPrediction(int homeBet, int awayBet, int actualHome, int actualAway) {
                Bet bet = buildBet(homeBet, awayBet, actualHome, actualAway);
                assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.WRONG);
            }
        }

        @Nested
        @DisplayName("Null safety — returns null when match data is incomplete")
        class NullSafetyTests {

            @Test
            @DisplayName("null match → null")
            void nullMatch() {
                Bet bet = Bet.builder()
                        .homeGoalsBet(1)
                        .awayGoalsBet(0)
                        .build();
                assertThat(bet.getCalculatedScoreTier()).isNull();
            }

            @Test
            @DisplayName("null homeGoals → null")
            void nullHomeGoals() {
                Match match = Match.builder().homeGoals(null).awayGoals(1).stage(MatchStage.GROUP_A).build();
                Bet bet = Bet.builder().match(match).homeGoalsBet(1).awayGoalsBet(0).build();
                assertThat(bet.getCalculatedScoreTier()).isNull();
            }

            @Test
            @DisplayName("null awayGoals → null")
            void nullAwayGoals() {
                Match match = Match.builder().homeGoals(1).awayGoals(null).stage(MatchStage.GROUP_A).build();
                Bet bet = Bet.builder().match(match).homeGoalsBet(1).awayGoalsBet(0).build();
                assertThat(bet.getCalculatedScoreTier()).isNull();
            }
        }
    }

    // ─── Points with Multiplier Tests ────────────────────────────────────

    @Nested
    @DisplayName("getCalculatedPoints()")
    class PointsTests {

        @ParameterizedTest(name = "EXACT in {4} (×{5}) → {6} pts")
        @CsvSource({
            "2, 1, 2, 1, GROUP_A,          1.0, 20",
            "2, 1, 2, 1, ROUND_OF_16,      1.5, 30",
            "2, 1, 2, 1, QUARTER_FINALS,    2.0, 40",
            "2, 1, 2, 1, FINAL,             3.0, 60",
        })
        void exactPoints(int hb, int ab, int ah, int aa, MatchStage stage, double mult, int expected) {
            Bet bet = buildBet(hb, ab, ah, aa, stage);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.EXACT);
            assertThat(bet.getCalculatedPoints()).isEqualTo(expected);
        }

        @ParameterizedTest(name = "DIFF in {4} (×{5}) → {6} pts")
        @CsvSource({
            "2, 0, 3, 1, GROUP_B,      1.0, 10",
            "2, 0, 3, 1, ROUND_OF_16,  1.5, 15",
        })
        void diffPoints(int hb, int ab, int ah, int aa, MatchStage stage, double mult, int expected) {
            Bet bet = buildBet(hb, ab, ah, aa, stage);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.DIFF);
            assertThat(bet.getCalculatedPoints()).isEqualTo(expected);
        }

        @Test
        @DisplayName("WINNER in QUARTER_FINALS (×2.0) → 12 pts")
        void winnerInQuarterFinals() {
            Bet bet = buildBet(3, 0, 1, 0, MatchStage.QUARTER_FINALS);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.WINNER);
            assertThat(bet.getCalculatedPoints()).isEqualTo(12);
        }

        @Test
        @DisplayName("INVERTED in SEMI_FINALS (×3.0) → 6 pts")
        void invertedInSemiFinals() {
            Bet bet = buildBet(0, 2, 2, 0, MatchStage.SEMI_FINALS);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.INVERTED);
            assertThat(bet.getCalculatedPoints()).isEqualTo(6);
        }

        @ParameterizedTest(name = "WRONG in {4} (×{5}) → {6} pts")
        @CsvSource({
            "2, 0, 0, 1, GROUP_C, 1.0, -6",
            "2, 0, 0, 1, FINAL,   3.0, -18",
        })
        void wrongPoints(int hb, int ab, int ah, int aa, MatchStage stage, double mult, int expected) {
            Bet bet = buildBet(hb, ab, ah, aa, stage);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.WRONG);
            assertThat(bet.getCalculatedPoints()).isEqualTo(expected);
        }

        @Test
        @DisplayName("null match → 0 pts")
        void nullMatchReturnsZero() {
            Bet bet = Bet.builder().homeGoalsBet(1).awayGoalsBet(0).build();
            assertThat(bet.getCalculatedPoints()).isEqualTo(0);
        }

        @Test
        @DisplayName("EXACT in THIRD_PLACE (×3.0) → 60 pts")
        void exactInThirdPlace() {
            Bet bet = buildBet(1, 1, 1, 1, MatchStage.THIRD_PLACE);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.EXACT);
            assertThat(bet.getCalculatedPoints()).isEqualTo(60);
        }

        @Test
        @DisplayName("EXACT in ROUND_OF_32 (×1.0) → 20 pts")
        void exactInRoundOf32() {
            Bet bet = buildBet(0, 0, 0, 0, MatchStage.ROUND_OF_32);
            assertThat(bet.getCalculatedScoreTier()).isEqualTo(ScoreTier.EXACT);
            assertThat(bet.getCalculatedPoints()).isEqualTo(20);
        }
    }
}
