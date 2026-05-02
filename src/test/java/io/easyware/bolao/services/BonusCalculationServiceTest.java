package io.easyware.bolao.services;

import io.easyware.bolao.entities.*;
import io.easyware.bolao.enums.*;
import io.easyware.bolao.repositories.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BonusCalculationServiceTest {

    @Mock
    MatchRepository matchRepository;

    @Mock
    BetRepository betRepository;

    @Mock
    PoolRepository poolRepository;

    @Mock
    UserPoolRepository userPoolRepository;

    @Mock
    PoolBonusRepository poolBonusRepository;

    @InjectMocks
    BonusCalculationService service;

    @Captor
    ArgumentCaptor<PoolBonus> bonusCaptor;

    // Shared test fixtures
    private Pool pool;
    private AppUser user1;
    private AppUser user2;
    private AppUser user3;

    @BeforeEach
    void setUp() {
        pool = Pool.builder().id(UUID.randomUUID()).name("Test Pool").build();
        user1 = AppUser.builder().id(UUID.randomUUID()).name("Alice").build();
        user2 = AppUser.builder().id(UUID.randomUUID()).name("Bob").build();
        user3 = AppUser.builder().id(UUID.randomUUID()).name("Carol").build();
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private Match createFinishedMatch(UUID id, MatchStage stage) {
        return Match.builder().id(id).stage(stage).status(MatchStatus.FINISHED).build();
    }

    private Bet createBet(AppUser user, Match match, int points) {
        return Bet.builder().user(user).match(match).pointsEarned(points).build();
    }

    private UserPool activeUserPool(AppUser user, Pool pool) {
        return UserPool.builder().user(user).pool(pool).status(UserPoolStatus.ACTIVE).build();
    }

    /**
     * Stubs matchRepository so that {@code isRoundComplete} returns true for the
     * given round and {@code getFinishedMatchIdsForRound} returns the supplied matches.
     */
    private void stubRoundComplete(TournamentRound round, List<Match> finishedMatches) {
        for (MatchStage stage : round.getStages()) {
            List<Match> stageMatches = finishedMatches.stream()
                    .filter(m -> m.getStage() == stage)
                    .toList();
            long count = stageMatches.size();
            // isRoundComplete checks
            lenient().when(matchRepository.count("stage", stage)).thenReturn(count);
            lenient().when(matchRepository.count("stage = ?1 and status = ?2", stage, MatchStatus.FINISHED))
                    .thenReturn(count);
            // getFinishedMatchIdsForRound
            lenient().when(matchRepository.findFinishedByStage(stage)).thenReturn(stageMatches);
        }
    }

    private void stubSingleStageRound(MatchStage stage, List<Match> matches) {
        lenient().when(matchRepository.count("stage", stage)).thenReturn((long) matches.size());
        lenient().when(matchRepository.count("stage = ?1 and status = ?2", stage, MatchStatus.FINISHED))
                .thenReturn((long) matches.size());
        lenient().when(matchRepository.findFinishedByStage(stage)).thenReturn(matches);
    }

    private void stubPoolInfrastructure(List<UserPool> members) {
        when(poolRepository.findActivePools()).thenReturn(List.of(pool));
        when(userPoolRepository.findByPoolAndStatus(pool.getId(), UserPoolStatus.ACTIVE)).thenReturn(members);
    }

    // ═════════════════════════════════════════════════════════════════════════
    //  Round Bonuses
    // ═════════════════════════════════════════════════════════════════════════

    @Nested
    @DisplayName("awardRoundBonuses")
    class RoundBonuses {

        @Test
        @DisplayName("3 users with distinct scores → rank 1 gets ROUND_BEST(+5), ranks 2-3 get ROUND_TOP3(+2)")
        void threeUsersDistinctScores() {
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32);
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool),
                    activeUserPool(user3, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 20),
                    createBet(user2, m1, 10),
                    createBet(user3, m1, 6)));

            service.awardRoundBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, times(3)).persist(bonusCaptor.capture());
            List<PoolBonus> bonuses = bonusCaptor.getAllValues();

            PoolBonus best = bonuses.stream()
                    .filter(b -> b.getUser().equals(user1)).findFirst().orElseThrow();
            assertThat(best.getBonusType()).isEqualTo(BonusType.ROUND_BEST);
            assertThat(best.getPointsEarned()).isEqualTo(5);
            assertThat(best.getTournamentRound()).isEqualTo(TournamentRound.ROUND_OF_32);

            for (AppUser u : List.of(user2, user3)) {
                PoolBonus top3 = bonuses.stream()
                        .filter(b -> b.getUser().equals(u)).findFirst().orElseThrow();
                assertThat(top3.getBonusType()).isEqualTo(BonusType.ROUND_TOP3);
                assertThat(top3.getPointsEarned()).isEqualTo(2);
            }
        }

        @Test
        @DisplayName("2 users tied for 1st → both ROUND_BEST(+5), 3rd user gets ROUND_TOP3(+2)")
        void twoUsersTiedForFirst() {
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_16);
            stubSingleStageRound(MatchStage.ROUND_OF_16, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool),
                    activeUserPool(user3, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 20),
                    createBet(user2, m1, 20),
                    createBet(user3, m1, 10)));

            service.awardRoundBonuses(TournamentRound.ROUND_OF_16);

            verify(poolBonusRepository, times(3)).persist(bonusCaptor.capture());
            List<PoolBonus> bonuses = bonusCaptor.getAllValues();

            long bestCount = bonuses.stream()
                    .filter(b -> b.getBonusType() == BonusType.ROUND_BEST).count();
            assertThat(bestCount).isEqualTo(2);

            PoolBonus top3 = bonuses.stream()
                    .filter(b -> b.getUser().equals(user3)).findFirst().orElseThrow();
            assertThat(top3.getBonusType()).isEqualTo(BonusType.ROUND_TOP3);
            assertThat(top3.getPointsEarned()).isEqualTo(2);
        }

        @Test
        @DisplayName("All users same score → all rank 1, all get ROUND_BEST(+5)")
        void allUsersSameScore() {
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.QUARTER_FINALS);
            stubSingleStageRound(MatchStage.QUARTER_FINALS, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool),
                    activeUserPool(user3, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 10),
                    createBet(user2, m1, 10),
                    createBet(user3, m1, 10)));

            service.awardRoundBonuses(TournamentRound.QUARTER_FINALS);

            verify(poolBonusRepository, times(3)).persist(bonusCaptor.capture());
            bonusCaptor.getAllValues().forEach(b -> {
                assertThat(b.getBonusType()).isEqualTo(BonusType.ROUND_BEST);
                assertThat(b.getPointsEarned()).isEqualTo(5);
            });
        }

        @Test
        @DisplayName("Idempotent: already awarded → no new bonuses persisted")
        void idempotentSkipsIfAlreadyAwarded() {
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(
                    createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32)));
            when(poolRepository.findActivePools()).thenReturn(List.of(pool));
            when(poolBonusRepository.existsByPoolAndTypeAndRound(
                    pool.getId(), BonusType.ROUND_BEST, TournamentRound.ROUND_OF_32))
                    .thenReturn(true);

            service.awardRoundBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, never()).persist(any(PoolBonus.class));
        }

        @Test
        @DisplayName("Pool with < 2 members → skips (no bonuses)")
        void skipsPoolWithFewerThanTwoMembers() {
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32);
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(m1));
            stubPoolInfrastructure(List.of(activeUserPool(user1, pool)));

            service.awardRoundBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, never()).persist(any(PoolBonus.class));
        }

        @Test
        @DisplayName("No bets for round → empty pointsByUser → skips")
        void noBetsForRound() {
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32);
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(Collections.emptyList());

            service.awardRoundBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, never()).persist(any(PoolBonus.class));
        }
    }

    // ═════════════════════════════════════════════════════════════════════════
    //  Recovery Bonuses
    // ═════════════════════════════════════════════════════════════════════════

    @Nested
    @DisplayName("awardRecoveryBonuses")
    class RecoveryBonuses {

        @Test
        @DisplayName("Users strictly above average get RECOVERY(+10)")
        void usersAboveAverageGetRecovery() {
            // scores: 100, 80, 60 → avg=80 → only user1 (100) is above
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32);
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool),
                    activeUserPool(user3, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 100),
                    createBet(user2, m1, 80),
                    createBet(user3, m1, 60)));

            service.awardRecoveryBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, times(1)).persist(bonusCaptor.capture());
            PoolBonus bonus = bonusCaptor.getValue();
            assertThat(bonus.getUser()).isEqualTo(user1);
            assertThat(bonus.getBonusType()).isEqualTo(BonusType.RECOVERY);
            assertThat(bonus.getPointsEarned()).isEqualTo(10);
            assertThat(bonus.getTournamentRound()).isEqualTo(TournamentRound.ROUND_OF_16);
        }

        @Test
        @DisplayName("User exactly at average gets nothing (strict >)")
        void userAtAverageGetsNothing() {
            // scores: 100, 80, 60 → avg=80 → user2 at average does NOT get bonus
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32);
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool),
                    activeUserPool(user3, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 100),
                    createBet(user2, m1, 80),
                    createBet(user3, m1, 60)));

            service.awardRecoveryBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, times(1)).persist(bonusCaptor.capture());
            List<UUID> awardedUserIds = bonusCaptor.getAllValues().stream()
                    .map(b -> b.getUser().getId()).toList();
            assertThat(awardedUserIds).doesNotContain(user2.getId());
        }

        @Test
        @DisplayName("All users same score → avg equals score → nobody gets bonus")
        void allUsersSameScoreNoRecovery() {
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32);
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool),
                    activeUserPool(user3, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 50),
                    createBet(user2, m1, 50),
                    createBet(user3, m1, 50)));

            service.awardRecoveryBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, never()).persist(any(PoolBonus.class));
        }

        @Test
        @DisplayName("FINAL round → nextRound is null → skips entirely")
        void finalRoundSkipsRecovery() {
            service.awardRecoveryBonuses(TournamentRound.FINAL);

            verifyNoInteractions(matchRepository, betRepository, poolRepository,
                    userPoolRepository, poolBonusRepository);
        }

        @Test
        @DisplayName("Recovery tagged with next round — GROUP_STAGE → tagged ROUND_OF_32")
        void recoveryTaggedWithNextRound() {
            // Use ROUND_OF_16 stage (single stage), next round = QUARTER_FINALS
            Match m1 = createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_16);
            stubSingleStageRound(MatchStage.ROUND_OF_16, List.of(m1));
            stubPoolInfrastructure(List.of(
                    activeUserPool(user1, pool),
                    activeUserPool(user2, pool)));

            when(betRepository.findByMatch(m1.getId())).thenReturn(List.of(
                    createBet(user1, m1, 30),
                    createBet(user2, m1, 10)));

            service.awardRecoveryBonuses(TournamentRound.ROUND_OF_16);

            verify(poolBonusRepository).persist(bonusCaptor.capture());
            assertThat(bonusCaptor.getValue().getTournamentRound())
                    .isEqualTo(TournamentRound.QUARTER_FINALS);
        }

        @Test
        @DisplayName("Idempotent: recovery already awarded → no new persists")
        void idempotentSkipsRecovery() {
            stubSingleStageRound(MatchStage.ROUND_OF_32, List.of(
                    createFinishedMatch(UUID.randomUUID(), MatchStage.ROUND_OF_32)));
            when(poolRepository.findActivePools()).thenReturn(List.of(pool));
            when(poolBonusRepository.existsByPoolAndTypeAndRound(
                    pool.getId(), BonusType.RECOVERY, TournamentRound.ROUND_OF_16))
                    .thenReturn(true);

            service.awardRecoveryBonuses(TournamentRound.ROUND_OF_32);

            verify(poolBonusRepository, never()).persist(any(PoolBonus.class));
        }
    }
}
