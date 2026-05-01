package io.easyware.bolao.enums;

public enum MatchStage {
    GROUP_A(1.0),
    GROUP_B(1.0),
    GROUP_C(1.0),
    GROUP_D(1.0),
    GROUP_E(1.0),
    GROUP_F(1.0),
    GROUP_G(1.0),
    GROUP_H(1.0),
    GROUP_I(1.0),
    GROUP_J(1.0),
    GROUP_K(1.0),
    GROUP_L(1.0),
    ROUND_OF_32(1.0),
    ROUND_OF_16(1.5),
    QUARTER_FINALS(2.0),
    SEMI_FINALS(3.0),
    THIRD_PLACE(3.0),
    FINAL(3.0);

    private final double multiplier;

    MatchStage(double multiplier) {
        this.multiplier = multiplier;
    }

    public double getMultiplier() {
        return multiplier;
    }
}
