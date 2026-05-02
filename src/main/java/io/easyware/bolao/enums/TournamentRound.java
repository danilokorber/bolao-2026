package io.easyware.bolao.enums;

import java.util.List;
import java.util.Set;

public enum TournamentRound {
    GROUP_STAGE(List.of(
            MatchStage.GROUP_A, MatchStage.GROUP_B, MatchStage.GROUP_C, MatchStage.GROUP_D,
            MatchStage.GROUP_E, MatchStage.GROUP_F, MatchStage.GROUP_G, MatchStage.GROUP_H,
            MatchStage.GROUP_I, MatchStage.GROUP_J, MatchStage.GROUP_K, MatchStage.GROUP_L)),
    ROUND_OF_32(List.of(MatchStage.ROUND_OF_32)),
    ROUND_OF_16(List.of(MatchStage.ROUND_OF_16)),
    QUARTER_FINALS(List.of(MatchStage.QUARTER_FINALS)),
    SEMI_FINALS(List.of(MatchStage.SEMI_FINALS, MatchStage.THIRD_PLACE)),
    FINAL(List.of(MatchStage.FINAL));

    private final List<MatchStage> stages;

    TournamentRound(List<MatchStage> stages) {
        this.stages = stages;
    }

    public List<MatchStage> getStages() {
        return stages;
    }

    public TournamentRound nextRound() {
        TournamentRound[] values = values();
        int next = ordinal() + 1;
        return next < values.length ? values[next] : null;
    }

    public static TournamentRound fromMatchStage(MatchStage stage) {
        for (TournamentRound round : values()) {
            if (round.stages.contains(stage)) {
                return round;
            }
        }
        return null;
    }
}
