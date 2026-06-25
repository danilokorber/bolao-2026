package io.easyware.bolao.services;

import io.easyware.bolao.entities.Bet;
import io.easyware.bolao.entities.ChampionBet;
import io.easyware.bolao.entities.GroupWinnerBet;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.repositories.BetRepository;
import io.easyware.bolao.repositories.ChampionBetRepository;
import io.easyware.bolao.repositories.GroupWinnerBetRepository;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Calculates and persists points for bets.
 *
 * <p>This service is designed for efficiency: it only processes bets for specific matches
 * whose scores have changed, rather than recalculating all bets in the database.
 *
 * <p>Points are evaluated in <strong>real time</strong>: from the moment a match kicks off
 * and throughout the game as goals are scored, bet points are continuously recalculated.
 * When the match finishes, the final score is locked in and group winner / champion bet
 * evaluation is triggered if applicable.
 *
 * <h3>Match Bet Scoring (90-minute result only)</h3>
 * <ul>
 *   <li>Exact score: 10 points</li>
 *   <li>Correct goal difference (implies correct winner): 5 points</li>
 *   <li>Correct winner, wrong margin: 3 points</li>
 *   <li>Inverted exact score (fun factor): 1 point</li>
 *   <li>Wrong prediction: -3 points</li>
 * </ul>
 *
 * <h3>Group Winner Bet Scoring</h3>
 * The admin-resolved knockout slots (WG{x} = winner, RG{x} = runner-up) are the
 * authoritative source of each group's 1st/2nd place — they already encode the
 * official FIFA tiebreakers (head-to-head, fair play, drawing of lots), which a
 * pure points/goal-difference sort cannot reproduce. Bets are (re)scored whenever
 * the admin resolves those slots, and the operation no-ops until both are set.
 * <ul>
 *   <li>Correct 1st place: 5 points</li>
 *   <li>Correct 2nd place: 3 points</li>
 *   <li>Both correct: +2 bonus (total 10)</li>
 * </ul>
 *
 * <h3>Champion Bet Scoring</h3>
 * Triggered when the final match is finished.
 * <ul>
 *   <li>Correct champion: 20 points</li>
 *   <li>Correct runner-up: 10 points</li>
 *   <li>Each correct semifinalist: 5 points (not counted if already rewarded as champion/runner-up)</li>
 * </ul>
 */
@ApplicationScoped
@Slf4j
public class ScoreCalculationService {

    @Inject
    BetRepository betRepository;

    @Inject
    MatchRepository matchRepository;

    @Inject
    GroupWinnerBetRepository groupWinnerBetRepository;

    @Inject
    ChampionBetRepository championBetRepository;

    @Inject
    TeamRepository teamRepository;

    /** Returns the current instant as a UTC LocalDateTime. */
    private static LocalDateTime nowUtc() {
        return LocalDateTime.now(ZoneOffset.UTC);
    }

    /**
     * Calculates and persists points for all bets on the given matches.
     * Only processes matches that are in FINISHED status and have valid scores.
     *
     * <p>This is the main entry point called by the scheduler after match results are updated.
     * It handles match bets directly, and also checks whether completing these matches triggers
     * group winner or champion bet evaluation.
     *
     * @param matchIds the UUIDs of matches that just finished
     * @return the total number of bets updated
     */
    @Transactional
    public int calculatePointsForMatches(List<UUID> matchIds) {
        if (matchIds == null || matchIds.isEmpty()) {
            return 0;
        }

        int totalUpdated = 0;

        // 1. Score match bets
        totalUpdated += scoreMatchBets(matchIds);

        // 2. Check if any completed group triggers group winner bet scoring
        totalUpdated += checkAndScoreGroupWinnerBets(matchIds);

        // 3. Check if the final just finished → score champion bets
        totalUpdated += checkAndScoreChampionBets(matchIds);

        log.info("Score calculation complete: {} bet(s) updated for {} match(es)", totalUpdated, matchIds.size());
        return totalUpdated;
    }

    /**
     * Recalculates points for ALL bets on a single match.
     * Useful for manual corrections (e.g. score was amended after initial FINISHED status).
     *
     * @param matchId the match UUID to recalculate
     * @return number of bets updated
     */
    @Transactional
    public int recalculateForMatch(UUID matchId) {
        Match match = matchRepository.findById(matchId);
        if (match == null) {
            log.warn("Cannot recalculate: match {} not found", matchId);
            return 0;
        }
        if (match.getStatus() != MatchStatus.FINISHED && match.getStatus() != MatchStatus.LIVE) {
            log.warn("Cannot recalculate: match {} is not LIVE or FINISHED (status: {})", matchId, match.getStatus());
            return 0;
        }
        if (match.getMatchDatetime().isAfter(nowUtc())) {
            log.warn("Cannot recalculate: match {} has not started yet (kickoff: {})", matchId, match.getMatchDatetime());
            return 0;
        }

        List<Bet> bets = betRepository.findByMatch(matchId);
        int updated = 0;
        for (Bet bet : bets) {
            int points = bet.getCalculatedPoints();
            var tier = bet.getCalculatedScoreTier();
            if (!Objects.equals(bet.getPointsEarned(), points) || !Objects.equals(bet.getScoreTier(), tier)) {
                bet.setPointsEarned(points);
                bet.setScoreTier(tier);
                updated++;
            }
        }
        log.info("Recalculated match {}: {}/{} bets updated", match.getMatchId(), updated, bets.size());
        return updated;
    }

    /**
     * Recalculates points for ALL bets on every match that has a result
     * (status LIVE or FINISHED with non-null scores).
     * Also directly recalculates all group winner bets (for complete groups)
     * and champion bets (if the final is finished).
     * Useful for a full re-score after a bug fix or scoring rule change.
     *
     * @return a summary with the number of matches processed and bets updated
     */
    @Transactional
    public RecalculateAllResult recalculateAll() {
        LocalDateTime now = nowUtc();
        List<Match> matchesWithResults = matchRepository
                .list("(status = ?1 or status = ?2) and homeGoals is not null and awayGoals is not null and matchDatetime < ?3",
                      MatchStatus.LIVE, MatchStatus.FINISHED, now);

        int totalBetsUpdated = 0;
        for (Match match : matchesWithResults) {
            List<Bet> bets = betRepository.findByMatch(match.getId());
            for (Bet bet : bets) {
                int points = bet.getCalculatedPoints();
                var tier = bet.getCalculatedScoreTier();
                if (!Objects.equals(bet.getPointsEarned(), points) || !Objects.equals(bet.getScoreTier(), tier)) {
                    bet.setPointsEarned(points);
                    bet.setScoreTier(tier);
                    totalBetsUpdated++;
                }
            }
        }

        // Directly score all complete groups
        totalBetsUpdated += scoreAllCompleteGroupWinnerBets();

        // Directly score champion bets if the final is finished
        totalBetsUpdated += scoreChampionBetsIfFinalFinished();

        log.info("Full recalculation: {} match(es) processed, {} bet(s) updated",
                matchesWithResults.size(), totalBetsUpdated);
        return new RecalculateAllResult(matchesWithResults.size(), totalBetsUpdated);
    }

    /**
     * Result of a full recalculation across all matches with results.
     */
    public record RecalculateAllResult(int matchesProcessed, int betsUpdated) {}

    // ── Match bets ──────────────────────────────────────────────────────────────

    private int scoreMatchBets(List<UUID> matchIds) {
        List<Bet> bets = betRepository.findByMatchIds(matchIds);
        if (bets.isEmpty()) {
            log.debug("No bets found for the {} match(es)", matchIds.size());
            return 0;
        }

        LocalDateTime now = nowUtc();
        int updated = 0;
        for (Bet bet : bets) {
            Match match = bet.getMatch();
            if (match == null) {
                continue;
            }
            // Score bets for LIVE and FINISHED matches (real-time updates)
            if (match.getStatus() != MatchStatus.LIVE && match.getStatus() != MatchStatus.FINISHED) {
                continue;
            }
            // Never score future matches
            if (match.getMatchDatetime().isAfter(now)) {
                continue;
            }
            int points = bet.getCalculatedPoints();
            var tier = bet.getCalculatedScoreTier();
            if (!Objects.equals(bet.getPointsEarned(), points) || !Objects.equals(bet.getScoreTier(), tier)) {
                bet.setPointsEarned(points);
                bet.setScoreTier(tier);
                updated++;
            }
        }

        log.info("Scored {} match bet(s) across {} match(es)", updated, matchIds.size());
        return updated;
    }

    // ── Group winner bets ───────────────────────────────────────────────────────

    private int checkAndScoreGroupWinnerBets(List<UUID> matchIds) {
        // Determine which groups are affected by the newly finished matches
        Set<GroupName> affectedGroups = matchIds.stream()
                .map(matchRepository::findById)
                .filter(Objects::nonNull)
                .map(Match::getStage)
                .filter(this::isGroupStage)
                .map(stage -> GroupName.valueOf(stage.name()))
                .collect(Collectors.toSet());

        int totalUpdated = 0;
        for (GroupName groupName : affectedGroups) {
            // 1st/2nd place are taken from the admin-resolved WG/RG slots, not from
            // derived standings. No-ops until the admin has resolved both slots.
            totalUpdated += scoreGroupWinnerBetsFromResolvedSlots(groupName);
        }
        return totalUpdated;
    }

    /**
     * Scores group winner bets for a single group using the manually resolved
     * knockout slots (WG{letter} = 1st place, RG{letter} = 2nd place) rather than
     * deriving standings from match results.
     *
     * <p>This is the <strong>authoritative</strong> source: the admin resolves these
     * slots applying FIFA tiebreakers (head-to-head, fair play, drawing of lots) that
     * a pure points/goal-difference sort cannot reproduce.
     *
     * <p>No-ops until <em>both</em> the winner and runner-up slots for the group have
     * been resolved, so it is safe to call after resolving either slot.
     *
     * @param groupName the group to score (e.g. {@code GROUP_A})
     * @return the number of bets whose points changed
     */
    @Transactional
    public int scoreGroupWinnerBetsFromResolvedSlots(GroupName groupName) {
        // GroupName is GROUP_A..GROUP_L; slot fifa codes are WG{A..L} / RG{A..L}.
        String letter = groupName.name().substring("GROUP_".length());

        Team winnerSlot = teamRepository.findByFifaCode("WG" + letter);
        Team runnerSlot = teamRepository.findByFifaCode("RG" + letter);

        if (winnerSlot == null || runnerSlot == null) {
            log.warn("Missing slot placeholder(s) for {} (WG{}/RG{}) — skipping slot-based scoring",
                    groupName, letter, letter);
            return 0;
        }

        Team first = winnerSlot.getResolvedTeam();
        Team second = runnerSlot.getResolvedTeam();

        if (first == null || second == null) {
            log.info("Group {} not fully resolved yet (1st: {}, 2nd: {}) — skipping slot-based scoring",
                    groupName,
                    first == null ? "?" : first.getFifaCode(),
                    second == null ? "?" : second.getFifaCode());
            return 0;
        }

        List<GroupWinnerBet> bets = groupWinnerBetRepository.findByGroup(groupName);
        int updated = 0;
        for (GroupWinnerBet bet : bets) {
            int points = bet.calculatePoints(first, second);
            if (!Objects.equals(bet.getPointsEarned(), points)) {
                bet.setPointsEarned(points);
                updated++;
            }
        }

        log.info("Scored {} group winner bet(s) for {} from resolved slots (1st: {}, 2nd: {})",
                updated, groupName, first.getFifaCode(), second.getFifaCode());
        return updated;
    }

    // ── Group winner bets (direct, for recalculateAll) ────────────────────────

    /**
     * Iterates all groups and scores group winner bets from the admin-resolved
     * WG/RG slots. Groups whose winner/runner-up have not been resolved are skipped.
     * Used by recalculateAll to avoid the indirect match-ID-based lookup.
     */
    private int scoreAllCompleteGroupWinnerBets() {
        int totalUpdated = 0;
        for (GroupName groupName : GroupName.values()) {
            // Source of truth: the admin-resolved WG/RG slots. No-ops for groups
            // whose winner/runner-up have not been resolved yet.
            totalUpdated += scoreGroupWinnerBetsFromResolvedSlots(groupName);
        }
        return totalUpdated;
    }

    /**
     * Scores champion bets if the final match is finished.
     * Used by recalculateAll to avoid the indirect match-ID-based lookup.
     */
    private int scoreChampionBetsIfFinalFinished() {
        LocalDateTime now = nowUtc();
        List<Match> finals = matchRepository.findByStage(MatchStage.FINAL);
        boolean finalFinished = finals.stream()
                .anyMatch(m -> m.getStatus() == MatchStatus.FINISHED
                        && m.getWinner() != null
                        && m.getMatchDatetime().isBefore(now));
        return finalFinished ? scoreChampionBets() : 0;
    }

    // ── Champion bets ───────────────────────────────────────────────────────────

    private int checkAndScoreChampionBets(List<UUID> matchIds) {
        LocalDateTime now = nowUtc();
        boolean finalJustFinished = matchIds.stream()
                .map(matchRepository::findById)
                .filter(Objects::nonNull)
                .anyMatch(m -> m.getStage() == MatchStage.FINAL
                        && m.getStatus() == MatchStatus.FINISHED
                        && m.getMatchDatetime().isBefore(now));

        if (!finalJustFinished) {
            return 0;
        }

        return scoreChampionBets();
    }

    private int scoreChampionBets() {
        // Find the final match
        LocalDateTime now = nowUtc();
        List<Match> finals = matchRepository.findByStage(MatchStage.FINAL);
        Match finalMatch = finals.stream()
                .filter(m -> m.getStatus() == MatchStatus.FINISHED)
                .filter(m -> m.getMatchDatetime().isBefore(now))
                .findFirst()
                .orElse(null);

        if (finalMatch == null || finalMatch.getWinner() == null) {
            log.warn("Final match not found or winner not set — skipping champion bet scoring");
            return 0;
        }

        Team champion = finalMatch.getWinner();

        // Determine runner-up (the team in the final that did NOT win)
        Team runnerUp = finalMatch.getHomeTeam().getId().equals(champion.getId())
                ? finalMatch.getAwayTeam()
                : finalMatch.getHomeTeam();

        // Collect semifinalists from semi-final matches
        List<Match> semiFinals = matchRepository.findFinishedByStage(MatchStage.SEMI_FINALS);
        Set<Team> semifinalists = new HashSet<>();
        for (Match sf : semiFinals) {
            if (sf.getHomeTeam() != null) semifinalists.add(sf.getHomeTeam());
            if (sf.getAwayTeam() != null) semifinalists.add(sf.getAwayTeam());
        }
        // Remove champion and runner-up — they advanced past semis
        // Actually the semifinalists are all 4 teams that played in the semis
        // The champion bet entity has 4 semifinalist slots, and the check is against all 4
        Team[] semifinalistArray = semifinalists.toArray(new Team[0]);

        List<ChampionBet> bets = championBetRepository.listAll();
        int updated = 0;
        for (ChampionBet bet : bets) {
            int points = bet.calculatePoints(champion, runnerUp, semifinalistArray);
            if (!Objects.equals(bet.getBonusPoints(), points)) {
                bet.setBonusPoints(points);
                updated++;
            }
        }

        log.info("Scored {} champion bet(s) — Champion: {}, Runner-up: {}, Semifinalists: {}",
                updated, champion.getFifaCode(), runnerUp.getFifaCode(),
                semifinalists.stream().map(Team::getFifaCode).collect(Collectors.joining(", ")));
        return updated;
    }

    private boolean isGroupStage(MatchStage stage) {
        return stage != null && stage.name().startsWith("GROUP_");
    }
}
