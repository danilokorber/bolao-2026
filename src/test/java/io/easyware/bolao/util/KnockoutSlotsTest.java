package io.easyware.bolao.util;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class KnockoutSlotsTest {

    @Test
    void winnerSlotUsesWPrefixForMatchesUpTo99() {
        assertThat(KnockoutSlots.winnerSlot(73)).isEqualTo("W73");
        assertThat(KnockoutSlots.winnerSlot(88)).isEqualTo("W88");
        assertThat(KnockoutSlots.winnerSlot(89)).isEqualTo("W89");
        assertThat(KnockoutSlots.winnerSlot(96)).isEqualTo("W96");
        assertThat(KnockoutSlots.winnerSlot(99)).isEqualTo("W99");
    }

    @Test
    void winnerSlotUsesWaPrefixForMatches100AndAbove() {
        assertThat(KnockoutSlots.winnerSlot(100)).isEqualTo("WA0");
        assertThat(KnockoutSlots.winnerSlot(101)).isEqualTo("WA1");
        assertThat(KnockoutSlots.winnerSlot(102)).isEqualTo("WA2");
        assertThat(KnockoutSlots.winnerSlot(103)).isEqualTo("WA3");
        assertThat(KnockoutSlots.winnerSlot(104)).isEqualTo("WA4");
    }

    @Test
    void loserSlotMapsSemifinalsToLaPrefix() {
        assertThat(KnockoutSlots.loserSlot(101)).isEqualTo("LA1");
        assertThat(KnockoutSlots.loserSlot(102)).isEqualTo("LA2");
    }
}
