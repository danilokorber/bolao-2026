package io.easyware.bolao.enums;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class MatchStageTest {

    private static final List<MatchStage> GROUP_STAGES = List.of(
            MatchStage.GROUP_A, MatchStage.GROUP_B, MatchStage.GROUP_C, MatchStage.GROUP_D,
            MatchStage.GROUP_E, MatchStage.GROUP_F, MatchStage.GROUP_G, MatchStage.GROUP_H,
            MatchStage.GROUP_I, MatchStage.GROUP_J, MatchStage.GROUP_K, MatchStage.GROUP_L);

    private static final double[] BASE_POINTS = {20, 10, 6, 2, -6};

    @ParameterizedTest
    @EnumSource(value = MatchStage.class, names = "GROUP_.*", mode = EnumSource.Mode.MATCH_ALL)
    void allGroupStagesHaveMultiplierOne(MatchStage stage) {
        assertThat(stage.getMultiplier()).isEqualTo(1.0);
    }

    @Test
    void groupStageCountIsTwelve() {
        assertThat(GROUP_STAGES).hasSize(12);
    }

    @Test
    void roundOf32HasMultiplierOne() {
        assertThat(MatchStage.ROUND_OF_32.getMultiplier()).isEqualTo(1.0);
    }

    @Test
    void roundOf16HasMultiplierOnePointFive() {
        assertThat(MatchStage.ROUND_OF_16.getMultiplier()).isEqualTo(1.5);
    }

    @Test
    void quarterFinalsHaveMultiplierTwo() {
        assertThat(MatchStage.QUARTER_FINALS.getMultiplier()).isEqualTo(2.0);
    }

    @ParameterizedTest
    @EnumSource(value = MatchStage.class, names = {"SEMI_FINALS", "THIRD_PLACE", "FINAL"})
    void lateStageshaveMultiplierThree(MatchStage stage) {
        assertThat(stage.getMultiplier()).isEqualTo(3.0);
    }

    @Test
    void totalEnumCountIsEighteen() {
        assertThat(MatchStage.values()).hasSize(18);
    }

    @ParameterizedTest
    @EnumSource(MatchStage.class)
    void allMultipliersProduceIntegerPointsWithBaseScores(MatchStage stage) {
        for (double base : BASE_POINTS) {
            double result = base * stage.getMultiplier();
            assertThat(result % 1.0)
                    .as("base=%s × multiplier=%s should be an integer", base, stage.getMultiplier())
                    .isEqualTo(0.0);
        }
    }
}
