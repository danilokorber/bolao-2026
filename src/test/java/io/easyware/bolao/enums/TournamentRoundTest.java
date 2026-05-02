package io.easyware.bolao.enums;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;

import java.util.HashSet;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class TournamentRoundTest {

    @Test
    void fromMatchStage_groupA_returnsGroupStage() {
        assertThat(TournamentRound.fromMatchStage(MatchStage.GROUP_A))
                .isEqualTo(TournamentRound.GROUP_STAGE);
    }

    @Test
    void fromMatchStage_groupL_returnsGroupStage() {
        assertThat(TournamentRound.fromMatchStage(MatchStage.GROUP_L))
                .isEqualTo(TournamentRound.GROUP_STAGE);
    }

    @Test
    void fromMatchStage_roundOf32_returnsRoundOf32() {
        assertThat(TournamentRound.fromMatchStage(MatchStage.ROUND_OF_32))
                .isEqualTo(TournamentRound.ROUND_OF_32);
    }

    @Test
    void fromMatchStage_semiFinals_returnsSemiFinals() {
        assertThat(TournamentRound.fromMatchStage(MatchStage.SEMI_FINALS))
                .isEqualTo(TournamentRound.SEMI_FINALS);
    }

    @Test
    void fromMatchStage_thirdPlace_returnsSemiFinals() {
        assertThat(TournamentRound.fromMatchStage(MatchStage.THIRD_PLACE))
                .isEqualTo(TournamentRound.SEMI_FINALS);
    }

    @Test
    void fromMatchStage_final_returnsFinal() {
        assertThat(TournamentRound.fromMatchStage(MatchStage.FINAL))
                .isEqualTo(TournamentRound.FINAL);
    }

    @Test
    void nextRound_groupStage_returnsRoundOf32() {
        assertThat(TournamentRound.GROUP_STAGE.nextRound())
                .isEqualTo(TournamentRound.ROUND_OF_32);
    }

    @Test
    void nextRound_semiFinals_returnsFinal() {
        assertThat(TournamentRound.SEMI_FINALS.nextRound())
                .isEqualTo(TournamentRound.FINAL);
    }

    @Test
    void nextRound_final_returnsNull() {
        assertThat(TournamentRound.FINAL.nextRound()).isNull();
    }

    @ParameterizedTest
    @EnumSource(MatchStage.class)
    void everyMatchStageMapsToExactlyOneTournamentRound(MatchStage stage) {
        int count = 0;
        for (TournamentRound round : TournamentRound.values()) {
            if (round.getStages().contains(stage)) {
                count++;
            }
        }
        assertThat(count)
                .as("%s should appear in exactly one TournamentRound", stage)
                .isEqualTo(1);
    }

    @Test
    void groupStageHasTwelveStages() {
        assertThat(TournamentRound.GROUP_STAGE.getStages()).hasSize(12);
    }

    @ParameterizedTest
    @EnumSource(value = TournamentRound.class, names = "GROUP_STAGE", mode = EnumSource.Mode.EXCLUDE)
    void nonGroupRoundsHaveOneOrTwoStages(TournamentRound round) {
        assertThat(round.getStages().size()).isBetween(1, 2);
    }

    @Test
    void totalRoundCountIsSix() {
        assertThat(TournamentRound.values()).hasSize(6);
    }
}
