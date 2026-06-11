package io.easyware.bolao.services;

import io.easyware.bolao.clients.FootballDataClient;
import io.easyware.bolao.dto.footballdata.FootballDataMatch;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.repositories.MatchRepository;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class FootballDataServiceTest {

    @Mock
    MatchRepository matchRepository;

    @Mock
    PanacheQuery<Match> panacheQuery;

    private FootballDataService service;

    @BeforeEach
    void setUp() {
        service = new FootballDataService();
        service.matchRepository = matchRepository;
    }

    @Test
    void promotesScheduledMatchToLiveWhenKickoffHasPassed() {
        UUID matchId = UUID.randomUUID();
        Match match = Match.builder()
                .id(matchId)
                .footballDataMatchId(537327)
                .status(MatchStatus.SCHEDULED)
                .matchDatetime(LocalDateTime.now(ZoneOffset.UTC).minusMinutes(1))
                .build();

        FootballDataMatch footballDataMatch = FootballDataMatch.builder()
                .id(537327L)
                .status("SCHEDULED")
                .utcDate(OffsetDateTime.now(ZoneOffset.UTC).minusMinutes(1))
                .build();

        when(matchRepository.find("footballDataMatchId", 537327L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        Optional<UUID> recalculatedMatchId = service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getStatus()).isEqualTo(MatchStatus.LIVE);
        assertThat(recalculatedMatchId).contains(matchId);
        verify(matchRepository).persist(match);
    }

    @Test
    void preservesLiveMatchWhenSnapshotFallsBackToScheduled() {
        UUID matchId = UUID.randomUUID();
        Match match = Match.builder()
                .id(matchId)
                .footballDataMatchId(537327)
                .status(MatchStatus.LIVE)
                .matchDatetime(LocalDateTime.now(ZoneOffset.UTC).minusMinutes(10))
                .build();

        FootballDataMatch footballDataMatch = FootballDataMatch.builder()
                .id(537327L)
                .status("SCHEDULED")
                .utcDate(OffsetDateTime.now(ZoneOffset.UTC).minusMinutes(1))
                .build();

        when(matchRepository.find("footballDataMatchId", 537327L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        Optional<UUID> recalculatedMatchId = service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getStatus()).isEqualTo(MatchStatus.LIVE);
        assertThat(recalculatedMatchId).isEmpty();
        verify(matchRepository).persist(match);
    }
}
