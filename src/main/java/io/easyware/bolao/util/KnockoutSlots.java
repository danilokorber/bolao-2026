package io.easyware.bolao.util;

/**
 * Maps a knockout match number ({@code match.matchId}, 73–104 in the World Cup 2026
 * schedule) to the synthetic placeholder {@code fifa_code} that the <em>next</em> match
 * uses to reference this match's winner (or, for semifinals, its loser).
 *
 * <p>The bracket is encoded purely through these placeholder slot codes (seeded in
 * {@code V2026.0.0.2}); resolving a slot to a real team re-points the next match's FK.
 *
 * <p>Encoding (a {@code fifa_code} is at most 3 characters):
 * <ul>
 *   <li>Winner of match {@code N} for {@code N} in 73–99 → {@code "W" + N} (e.g. {@code W73})</li>
 *   <li>Winner of match {@code N} for {@code N} in 100–104 → {@code "WA" + (N - 100)}
 *       (match 100 → {@code WA0} … match 104 → {@code WA4})</li>
 *   <li>Loser of semifinal {@code N} (101/102) → {@code "LA" + (N - 100)}
 *       ({@code LA1}/{@code LA2}, feeding the 3rd-place match)</li>
 * </ul>
 */
public final class KnockoutSlots {

    private KnockoutSlots() {
    }

    /**
     * Returns the placeholder slot code that references the winner of the given match.
     *
     * @param matchId the schedule match number (e.g. 73)
     * @return the winner slot code (e.g. {@code W73}, {@code WA0})
     */
    public static String winnerSlot(int matchId) {
        return matchId <= 99 ? "W" + matchId : "WA" + (matchId - 100);
    }

    /**
     * Returns the placeholder slot code that references the loser of the given match.
     * Only meaningful for the semifinals (101 → {@code LA1}, 102 → {@code LA2}), whose
     * losers feed the 3rd-place match.
     *
     * @param matchId the schedule match number (101 or 102)
     * @return the loser slot code (e.g. {@code LA1})
     */
    public static String loserSlot(int matchId) {
        return "LA" + (matchId - 100);
    }
}
