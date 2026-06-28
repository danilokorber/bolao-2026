package io.easyware.bolao.services;

import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import io.easyware.bolao.util.KnockoutSlots;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Set;

/**
 * Advances knockout results into the next match.
 *
 * <p>The bracket is encoded through synthetic placeholder slots: the winner of match {@code N}
 * is referenced by the next match as {@code W{N}} (see {@link KnockoutSlots}). When the external
 * API reports a knockout match as FINISHED, {@code FootballDataService} sets {@code Match.winner}
 * (penalty-aware, from {@code score.winner}); this service then resolves the corresponding
 * {@code W{N}} slot to that winner, re-pointing the downstream match's team FK via
 * {@link MatchService#resolveSlot(String, String)}. Semifinal <em>losers</em> are likewise
 * advanced into the 3rd-place match through their {@code LA{n}} slots.
 *
 * <p>The operation is a <strong>reconciliation scan</strong>: every invocation re-derives the
 * required slot resolutions from the current match results and skips slots already resolved to
 * the same team. This makes it idempotent and self-healing across restarts or missed scheduler
 * ticks. Each slot is resolved in its own transaction so a single failure cannot abort the batch.
 */
@ApplicationScoped
@Slf4j
public class KnockoutAdvancementService {

    /** Knockout stages whose winner feeds a later match. */
    private static final Set<MatchStage> WINNER_ADVANCING_STAGES = EnumSet.of(
            MatchStage.ROUND_OF_32,
            MatchStage.ROUND_OF_16,
            MatchStage.QUARTER_FINALS,
            MatchStage.SEMI_FINALS);

    @Inject
    MatchRepository matchRepository;

    @Inject
    TeamRepository teamRepository;

    @Inject
    MatchService matchService;

    /** A slot that should be resolved to a real team. */
    private record SlotResolution(String slotCode, String fifaCode, int matchId) {
    }

    /**
     * Resolves every knockout placeholder slot whose result is now known, advancing winners
     * (and semifinal losers) into their next match. Idempotent and safe to call repeatedly.
     *
     * <p>Runs in a single transaction: the reconciliation scan needs a session to read the eager
     * team associations and the (lazy) {@code resolvedTeam}, and the downstream re-pointing reuses
     * {@link MatchService#resolveSlot(String, String)}. For valid bracket data the resolutions
     * cannot raise {@code NotFoundException} (placeholder and winner rows always exist), and any
     * unexpected failure is simply retried on the next reconciliation tick.
     *
     * @return the number of downstream matches re-pointed to a real team
     */
    @Transactional
    public int advanceFinishedKnockoutMatches() {
        List<SlotResolution> tasks = collectPendingResolutions();
        if (tasks.isEmpty()) {
            return 0;
        }

        int updatedMatches = 0;
        for (SlotResolution task : tasks) {
            try {
                int updated = matchService.resolveSlot(task.slotCode(), task.fifaCode());
                updatedMatches += updated;
                log.info("Advanced match {} result into slot {} -> {} ({} downstream match(es) updated)",
                        task.matchId(), task.slotCode(), task.fifaCode(), updated);
            } catch (Exception e) {
                log.error("Failed to advance match {} into slot {} -> {}",
                        task.matchId(), task.slotCode(), task.fifaCode(), e);
            }
        }
        return updatedMatches;
    }

    /**
     * Scans finished knockout matches and derives the slot resolutions still needed, skipping
     * any slot already resolved to the intended team. Invoked within
     * {@link #advanceFinishedKnockoutMatches()}'s transaction so the eager team associations and
     * the (lazy) {@code resolvedTeam} can be inspected.
     */
    private List<SlotResolution> collectPendingResolutions() {
        LocalDateTime now = LocalDateTime.now(ZoneOffset.UTC);
        List<Match> matches = matchRepository.findFinishedWithWinnerByStages(WINNER_ADVANCING_STAGES, now);

        List<SlotResolution> tasks = new ArrayList<>();
        for (Match match : matches) {
            Team winner = match.getWinner();
            if (!isRealTeam(winner)) {
                log.warn("Match {} is FINISHED but its winner is not a resolved team — skipping advancement",
                        match.getMatchId());
                continue;
            }

            // Winner advances into W{matchId}.
            addIfUnresolved(tasks, KnockoutSlots.winnerSlot(match.getMatchId()), winner, match.getMatchId());

            // Semifinal losers feed the 3rd-place match via LA{n}.
            if (match.getStage() == MatchStage.SEMI_FINALS) {
                Team loser = loserOf(match, winner);
                if (isRealTeam(loser)) {
                    addIfUnresolved(tasks, KnockoutSlots.loserSlot(match.getMatchId()), loser, match.getMatchId());
                } else {
                    log.warn("Semifinal {} loser is not a resolved team — skipping 3rd-place advancement",
                            match.getMatchId());
                }
            }
        }
        return tasks;
    }

    /**
     * Queues a slot resolution unless the placeholder is missing or already points at the team.
     */
    private void addIfUnresolved(List<SlotResolution> tasks, String slotCode, Team team, int matchId) {
        Team placeholder = teamRepository.findByFifaCode(slotCode);
        if (placeholder == null) {
            log.debug("No placeholder slot {} for match {} — nothing to advance", slotCode, matchId);
            return;
        }
        Team resolved = placeholder.getResolvedTeam();
        if (resolved != null && team.getId().equals(resolved.getId())) {
            log.debug("Slot {} already resolved to {} — skipping", slotCode, team.getFifaCode());
            return;
        }
        tasks.add(new SlotResolution(slotCode, team.getFifaCode(), matchId));
    }

    private Team loserOf(Match match, Team winner) {
        Team home = match.getHomeTeam();
        Team away = match.getAwayTeam();
        if (home != null && winner.getId().equals(home.getId())) {
            return away;
        }
        return home;
    }

    /** A real qualifier has a flag URL; placeholder slots are seeded with a null flag. */
    private boolean isRealTeam(Team team) {
        return team != null && team.getFlagUrl() != null && !team.getFlagUrl().isBlank();
    }
}
