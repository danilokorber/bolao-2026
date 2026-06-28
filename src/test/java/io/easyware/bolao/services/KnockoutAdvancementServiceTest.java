package io.easyware.bolao.services;

import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class KnockoutAdvancementServiceTest {

    @Mock
    MatchRepository matchRepository;

    @Mock
    TeamRepository teamRepository;

    @Mock
    MatchService matchService;

    private KnockoutAdvancementService service;

    @BeforeEach
    void setUp() {
        service = new KnockoutAdvancementService();
        service.matchRepository = matchRepository;
        service.teamRepository = teamRepository;
        service.matchService = matchService;
    }

    @Test
    void advancesRoundOf32WinnerIntoWinnerSlot() {
        Team bra = realTeam("BRA");
        Team arg = realTeam("ARG");
        Match match = knockoutMatch(73, MatchStage.ROUND_OF_32, bra, arg, bra);

        stubFinishedMatches(match);
        Team slot = placeholder("W73", null);
        when(teamRepository.findByFifaCode("W73")).thenReturn(slot);
        when(matchService.resolveSlot("W73", "BRA")).thenReturn(1);

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isEqualTo(1);
        verify(matchService).resolveSlot("W73", "BRA");
    }

    @Test
    void advancesSemifinalWinnerAndLoserIntoBothSlots() {
        Team fra = realTeam("FRA");
        Team por = realTeam("POR");
        // match 101: home FRA wins, away POR loses
        Match match = knockoutMatch(101, MatchStage.SEMI_FINALS, fra, por, fra);

        stubFinishedMatches(match);
        when(teamRepository.findByFifaCode("WA1")).thenReturn(placeholder("WA1", null));
        when(teamRepository.findByFifaCode("LA1")).thenReturn(placeholder("LA1", null));
        when(matchService.resolveSlot("WA1", "FRA")).thenReturn(1);
        when(matchService.resolveSlot("LA1", "POR")).thenReturn(1);

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isEqualTo(2);
        verify(matchService).resolveSlot("WA1", "FRA");
        verify(matchService).resolveSlot("LA1", "POR");
    }

    @Test
    void skipsSlotAlreadyResolvedToSameTeam() {
        Team bra = realTeam("BRA");
        Team arg = realTeam("ARG");
        Match match = knockoutMatch(73, MatchStage.ROUND_OF_32, bra, arg, bra);

        stubFinishedMatches(match);
        // The W73 placeholder already points at BRA → nothing to do.
        when(teamRepository.findByFifaCode("W73")).thenReturn(placeholder("W73", bra));

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isZero();
        verify(matchService, never()).resolveSlot(anyString(), anyString());
    }

    @Test
    void reResolvesSlotWhenResolvedToADifferentTeam() {
        Team bra = realTeam("BRA");
        Team arg = realTeam("ARG");
        Team wrong = realTeam("URU");
        Match match = knockoutMatch(73, MatchStage.ROUND_OF_32, bra, arg, bra);

        stubFinishedMatches(match);
        when(teamRepository.findByFifaCode("W73")).thenReturn(placeholder("W73", wrong));
        when(matchService.resolveSlot("W73", "BRA")).thenReturn(1);

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isEqualTo(1);
        verify(matchService).resolveSlot("W73", "BRA");
    }

    @Test
    void skipsWhenWinnerIsNotAResolvedTeam() {
        Team placeholderWinner = placeholder("W73", null); // flagUrl null → not a real team
        Team arg = realTeam("ARG");
        Match match = knockoutMatch(73, MatchStage.ROUND_OF_32, placeholderWinner, arg, placeholderWinner);

        stubFinishedMatches(match);

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isZero();
        verify(matchService, never()).resolveSlot(anyString(), anyString());
    }

    @Test
    void skipsWhenWinnerPlaceholderSlotDoesNotExist() {
        Team bra = realTeam("BRA");
        Team arg = realTeam("ARG");
        Match match = knockoutMatch(73, MatchStage.ROUND_OF_32, bra, arg, bra);

        stubFinishedMatches(match);
        when(teamRepository.findByFifaCode("W73")).thenReturn(null);

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isZero();
        verify(matchService, never()).resolveSlot(anyString(), anyString());
    }

    @Test
    void doesNothingWhenNoFinishedKnockoutMatches() {
        stubFinishedMatches();

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isZero();
        verify(matchService, never()).resolveSlot(anyString(), anyString());
    }

    @Test
    void continuesAdvancingWhenOneSlotResolutionFails() {
        Team bra = realTeam("BRA");
        Team arg = realTeam("ARG");
        Team ger = realTeam("GER");
        Team esp = realTeam("ESP");
        Match good = knockoutMatch(73, MatchStage.ROUND_OF_32, bra, arg, bra);
        Match bad = knockoutMatch(74, MatchStage.ROUND_OF_32, ger, esp, ger);

        stubFinishedMatches(good, bad);
        when(teamRepository.findByFifaCode("W73")).thenReturn(placeholder("W73", null));
        when(teamRepository.findByFifaCode("W74")).thenReturn(placeholder("W74", null));
        when(matchService.resolveSlot("W74", "GER")).thenThrow(new RuntimeException("boom"));
        when(matchService.resolveSlot("W73", "BRA")).thenReturn(1);

        int updated = service.advanceFinishedKnockoutMatches();

        assertThat(updated).isEqualTo(1);
        verify(matchService).resolveSlot("W73", "BRA");
        verify(matchService).resolveSlot("W74", "GER");
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    private void stubFinishedMatches(Match... matches) {
        when(matchRepository.findFinishedWithWinnerByStages(any(), any()))
                .thenReturn(List.of(matches));
    }

    private static Team realTeam(String fifaCode) {
        return Team.builder()
                .id(UUID.randomUUID())
                .fifaCode(fifaCode)
                .flagUrl("https://flagcdn.com/w320/" + fifaCode.toLowerCase() + ".png")
                .build();
    }

    private static Team placeholder(String fifaCode, Team resolvedTeam) {
        return Team.builder()
                .id(UUID.randomUUID())
                .fifaCode(fifaCode)
                .flagUrl(null)
                .resolvedTeam(resolvedTeam)
                .build();
    }

    private static Match knockoutMatch(int matchId, MatchStage stage, Team home, Team away, Team winner) {
        return Match.builder()
                .id(UUID.randomUUID())
                .matchId(matchId)
                .stage(stage)
                .status(MatchStatus.FINISHED)
                .homeTeam(home)
                .awayTeam(away)
                .winner(winner)
                .matchDatetime(LocalDateTime.now(ZoneOffset.UTC).minusMinutes(120))
                .build();
    }
}
