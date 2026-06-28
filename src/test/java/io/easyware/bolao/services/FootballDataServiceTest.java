package io.easyware.bolao.services;

import io.easyware.bolao.clients.FootballDataClient;
import io.easyware.bolao.dto.footballdata.FootballDataMatch;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
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

    @Test
    void setsWinnerToHomeTeamWhenFinishedWithHomeTeamScoreWinner() {
        Team home = team("BRA");
        Team away = team("ARG");
        Match match = knockoutMatch(home, away, MatchStatus.LIVE);

        FootballDataMatch footballDataMatch = finishedSnapshot("HOME_TEAM", "REGULAR", 2, 1);

        when(matchRepository.find("footballDataMatchId", 537417L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getStatus()).isEqualTo(MatchStatus.FINISHED);
        assertThat(match.getWinner()).isSameAs(home);
    }

    @Test
    void setsWinnerToAwayTeamWhenFinishedWithAwayTeamScoreWinner() {
        Team home = team("BRA");
        Team away = team("ARG");
        Match match = knockoutMatch(home, away, MatchStatus.LIVE);

        FootballDataMatch footballDataMatch = finishedSnapshot("AWAY_TEAM", "REGULAR", 0, 3);

        when(matchRepository.find("footballDataMatchId", 537417L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getWinner()).isSameAs(away);
    }

    @Test
    void setsWinnerFromPenaltyShootoutUsingScoreWinner() {
        Team home = team("BRA");
        Team away = team("ARG");
        Match match = knockoutMatch(home, away, MatchStatus.LIVE);

        // Drawn after extra time (1–1), decided on penalties in favour of the away team.
        FootballDataMatch footballDataMatch = finishedSnapshot("AWAY_TEAM", "PENALTY_SHOOTOUT", 1, 1);

        when(matchRepository.find("footballDataMatchId", 537417L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getWentToPenalties()).isTrue();
        assertThat(match.getWentToExtraTime()).isTrue();
        assertThat(match.getWinner()).isSameAs(away);
    }

    @Test
    void doesNotSetWinnerWhenFinishedMatchIsADraw() {
        Team home = team("GER");
        Team away = team("ESP");
        Match match = knockoutMatch(home, away, MatchStatus.LIVE);

        FootballDataMatch footballDataMatch = finishedSnapshot("DRAW", "REGULAR", 1, 1);

        when(matchRepository.find("footballDataMatchId", 537417L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getWinner()).isNull();
    }

    @Test
    void doesNotSetWinnerWhileMatchIsStillLive() {
        Team home = team("BRA");
        Team away = team("ARG");
        Match match = knockoutMatch(home, away, MatchStatus.LIVE);

        FootballDataMatch footballDataMatch = FootballDataMatch.builder()
                .id(537417L)
                .status("IN_PLAY")
                .utcDate(OffsetDateTime.now(ZoneOffset.UTC).minusMinutes(30))
                .score(FootballDataMatch.Score.builder()
                        .winner("HOME_TEAM")
                        .duration("REGULAR")
                        .fullTime(FootballDataMatch.Score.TimeScore.builder().home(1).away(0).build())
                        .build())
                .build();

        when(matchRepository.find("footballDataMatchId", 537417L)).thenReturn(panacheQuery);
        when(panacheQuery.firstResultOptional()).thenReturn(Optional.of(match));
        doNothing().when(matchRepository).persist(any(Match.class));

        service.updateMatchFromFootballData(footballDataMatch);

        assertThat(match.getStatus()).isEqualTo(MatchStatus.LIVE);
        assertThat(match.getWinner()).isNull();
    }

    private static Team team(String fifaCode) {
        return Team.builder()
                .id(UUID.randomUUID())
                .fifaCode(fifaCode)
                .flagUrl("https://flagcdn.com/w320/" + fifaCode.toLowerCase() + ".png")
                .build();
    }

    private static Match knockoutMatch(Team home, Team away, MatchStatus status) {
        return Match.builder()
                .id(UUID.randomUUID())
                .footballDataMatchId(537417)
                .homeTeam(home)
                .awayTeam(away)
                .status(status)
                .matchDatetime(LocalDateTime.now(ZoneOffset.UTC).minusMinutes(120))
                .build();
    }

    private static FootballDataMatch finishedSnapshot(String winner, String duration, int home, int away) {
        return FootballDataMatch.builder()
                .id(537417L)
                .status("FINISHED")
                .utcDate(OffsetDateTime.now(ZoneOffset.UTC).minusMinutes(120))
                .score(FootballDataMatch.Score.builder()
                        .winner(winner)
                        .duration(duration)
                        .fullTime(FootballDataMatch.Score.TimeScore.builder().home(home).away(away).build())
                        .build())
                .build();
    }
}
