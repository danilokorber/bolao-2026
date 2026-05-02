package io.easyware.bolao.services;

import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.entities.Bet;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.PoolBonus;
import io.easyware.bolao.entities.UserPool;
import io.easyware.bolao.enums.BonusType;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.enums.TournamentRound;
import io.easyware.bolao.enums.UserPoolStatus;
import io.easyware.bolao.repositories.BetRepository;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.PoolBonusRepository;
import io.easyware.bolao.repositories.PoolRepository;
import io.easyware.bolao.repositories.UserPoolRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Awards per-pool bonuses after tournament rounds complete:
 * <ul>
 *   <li><b>Round Bonus</b>: Best predictor of the round gets +5 pts; 2nd and 3rd get +2 each.
 *       Ties share the same bonus.</li>
 *   <li><b>Recovery Bonus</b>: Users scoring strictly above pool average in a round
 *       get a flat +10 bonus (tagged with the next round).</li>
 * </ul>
 */
@ApplicationScoped
@Slf4j
public class BonusCalculationService {

    private static final int BEST_PREDICTOR_POINTS = 5;
    private static final int TOP3_POINTS = 2;
    private static final int RECOVERY_POINTS = 10;

    @Inject
    MatchRepository matchRepository;

    @Inject
    BetRepository betRepository;

    @Inject
    PoolRepository poolRepository;

    @Inject
    UserPoolRepository userPoolRepository;

    @Inject
    PoolBonusRepository poolBonusRepository;

    /**
     * Checks if the given match IDs complete any tournament round,
     * and if so, awards round bonuses and recovery bonuses for each active pool.
     */
    @Transactional
    public void checkAndAwardBonuses(List<UUID> matchIds) {
        Set<TournamentRound> affectedRounds = matchIds.stream()
                .map(matchRepository::findById)
                .filter(Objects::nonNull)
                .map(Match::getStage)
                .map(TournamentRound::fromMatchStage)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        for (TournamentRound round : affectedRounds) {
            if (isRoundComplete(round)) {
                awardRoundBonuses(round);
                awardRecoveryBonuses(round);
            }
        }
    }

    /**
     * Awards round bonuses (+5 best, +2 top 3) for each active pool.
     * Idempotent: skips pools that already have round bonuses for this round.
     */
    void awardRoundBonuses(TournamentRound round) {
        List<UUID> matchIds = getFinishedMatchIdsForRound(round);
        if (matchIds.isEmpty()) return;

        for (var pool : poolRepository.findActivePools()) {
            if (poolBonusRepository.existsByPoolAndTypeAndRound(pool.getId(), BonusType.ROUND_BEST, round)) {
                log.debug("Round bonuses already awarded for pool {} round {}", pool.getName(), round);
                continue;
            }

            List<UserPool> activeMembers = userPoolRepository.findByPoolAndStatus(pool.getId(), UserPoolStatus.ACTIVE);
            if (activeMembers.size() < 2) continue;

            Set<UUID> memberUserIds = activeMembers.stream()
                    .map(up -> up.getUser().getId())
                    .collect(Collectors.toSet());

            // Sum match bet points per user for this round
            Map<UUID, Long> pointsByUser = new HashMap<>();
            for (UUID matchId : matchIds) {
                List<Bet> bets = betRepository.findByMatch(matchId);
                for (Bet bet : bets) {
                    UUID userId = bet.getUser().getId();
                    if (memberUserIds.contains(userId) && bet.getPointsEarned() != null) {
                        pointsByUser.merge(userId, (long) bet.getPointsEarned(), Long::sum);
                    }
                }
            }

            if (pointsByUser.isEmpty()) continue;

            // Rank by points descending
            List<Map.Entry<UUID, Long>> ranked = pointsByUser.entrySet().stream()
                    .sorted(Map.Entry.<UUID, Long>comparingByValue().reversed())
                    .toList();

            // Award bonuses using dense ranking (ties share the same rank)
            int distinctRank = 0;
            long previousPoints = Long.MAX_VALUE;
            Map<UUID, AppUser> userCache = activeMembers.stream()
                    .collect(Collectors.toMap(up -> up.getUser().getId(), UserPool::getUser, (a, b) -> a));

            for (Map.Entry<UUID, Long> entry : ranked) {
                if (entry.getValue() < previousPoints) {
                    distinctRank++;
                    previousPoints = entry.getValue();
                }
                if (distinctRank > 3) break;

                BonusType type = (distinctRank == 1) ? BonusType.ROUND_BEST : BonusType.ROUND_TOP3;
                int points = (distinctRank == 1) ? BEST_PREDICTOR_POINTS : TOP3_POINTS;

                poolBonusRepository.persist(PoolBonus.builder()
                        .user(userCache.get(entry.getKey()))
                        .pool(pool)
                        .bonusType(type)
                        .tournamentRound(round)
                        .pointsEarned(points)
                        .calculatedAt(LocalDateTime.now())
                        .build());
            }

            log.info("Awarded round bonuses for pool '{}' round {}", pool.getName(), round);
        }
    }

    /**
     * Awards recovery bonuses (+10) for users strictly above pool average.
     * Tagged with the NEXT round. No recovery bonus after the final round.
     * Idempotent: skips pools that already have recovery bonuses for the next round.
     */
    void awardRecoveryBonuses(TournamentRound round) {
        TournamentRound nextRound = round.nextRound();
        if (nextRound == null) {
            log.debug("No next round after {} — skipping recovery bonus", round);
            return;
        }

        List<UUID> matchIds = getFinishedMatchIdsForRound(round);
        if (matchIds.isEmpty()) return;

        for (var pool : poolRepository.findActivePools()) {
            if (poolBonusRepository.existsByPoolAndTypeAndRound(pool.getId(), BonusType.RECOVERY, nextRound)) {
                log.debug("Recovery bonuses already awarded for pool {} next round {}", pool.getName(), nextRound);
                continue;
            }

            List<UserPool> activeMembers = userPoolRepository.findByPoolAndStatus(pool.getId(), UserPoolStatus.ACTIVE);
            if (activeMembers.size() < 2) continue;

            Set<UUID> memberUserIds = activeMembers.stream()
                    .map(up -> up.getUser().getId())
                    .collect(Collectors.toSet());

            // Sum match bet points per user for this round
            Map<UUID, Long> pointsByUser = new HashMap<>();
            for (UUID matchId : matchIds) {
                List<Bet> bets = betRepository.findByMatch(matchId);
                for (Bet bet : bets) {
                    UUID userId = bet.getUser().getId();
                    if (memberUserIds.contains(userId) && bet.getPointsEarned() != null) {
                        pointsByUser.merge(userId, (long) bet.getPointsEarned(), Long::sum);
                    }
                }
            }

            if (pointsByUser.isEmpty()) continue;

            // Calculate average
            double average = pointsByUser.values().stream()
                    .mapToLong(Long::longValue)
                    .average()
                    .orElse(0.0);

            Map<UUID, AppUser> userCache = activeMembers.stream()
                    .collect(Collectors.toMap(up -> up.getUser().getId(), UserPool::getUser, (a, b) -> a));

            int awarded = 0;
            for (Map.Entry<UUID, Long> entry : pointsByUser.entrySet()) {
                if (entry.getValue() > average) {
                    poolBonusRepository.persist(PoolBonus.builder()
                            .user(userCache.get(entry.getKey()))
                            .pool(pool)
                            .bonusType(BonusType.RECOVERY)
                            .tournamentRound(nextRound)
                            .pointsEarned(RECOVERY_POINTS)
                            .calculatedAt(LocalDateTime.now())
                            .build());
                    awarded++;
                }
            }

            if (awarded > 0) {
                log.info("Awarded {} recovery bonus(es) for pool '{}' (avg={}, next round={})",
                        awarded, pool.getName(), String.format("%.1f", average), nextRound);
            }
        }
    }

    private boolean isRoundComplete(TournamentRound round) {
        for (MatchStage stage : round.getStages()) {
            long total = matchRepository.count("stage", stage);
            long finished = matchRepository.count("stage = ?1 and status = ?2", stage, MatchStatus.FINISHED);
            if (total == 0 || total != finished) {
                return false;
            }
        }
        return true;
    }

    private List<UUID> getFinishedMatchIdsForRound(TournamentRound round) {
        List<UUID> ids = new ArrayList<>();
        for (MatchStage stage : round.getStages()) {
            matchRepository.findFinishedByStage(stage)
                    .forEach(m -> ids.add(m.getId()));
        }
        return ids;
    }
}
