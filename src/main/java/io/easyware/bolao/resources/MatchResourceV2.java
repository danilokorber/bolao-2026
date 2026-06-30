package io.easyware.bolao.resources;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.dto.MatchV2DTO;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.entities.Bet;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.mappers.BetMapper;
import io.easyware.bolao.mappers.MatchMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.BetRepository;
import io.easyware.bolao.repositories.MatchRepository;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.SecurityContext;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Path("/v2/matches")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class MatchResourceV2 {

    @Inject
    MatchRepository matchRepository;

    @Inject
    BetRepository betRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    MatchMapper matchMapper;

    @Inject
    BetMapper betMapper;

    @Context
    SecurityContext securityContext;

    @GET
    public List<MatchV2DTO> getAll() {
        String keycloakId = securityContext.getUserPrincipal().getName();
        AppUser currentUser = appUserRepository.findByEmail(keycloakId);

        List<Match> matches = matchRepository.listAll(io.quarkus.panache.common.Sort.by("matchDatetime"));
        LocalDateTime now = LocalDateTime.now();

        List<UUID> pastMatchIds = matches.stream()
                .filter(m -> m.getMatchDatetime().isBefore(now))
                .map(Match::getId)
                .toList();

        // Batch-load all bets for past matches
        Map<UUID, List<Bet>> betsByMatch = pastMatchIds.isEmpty()
                ? Collections.emptyMap()
                : betRepository.findByMatchIds(pastMatchIds).stream()
                    .collect(Collectors.groupingBy(b -> b.getMatch().getId()));

        // Batch-load current user's bets for future matches
        Map<UUID, Bet> userBetByMatch = currentUser == null
                ? Collections.emptyMap()
                : betRepository.findByUser(currentUser.getId()).stream()
                    .collect(Collectors.toMap(b -> b.getMatch().getId(), b -> b, (a, b) -> a));

        List<MatchV2DTO> result = new ArrayList<>(matches.size());
        for (Match match : matches) {
            MatchV2DTO dto = toV2DTO(match);

            if (match.getMatchDatetime().isBefore(now)) {
                // Past match: include all bets
                List<Bet> allBets = betsByMatch.getOrDefault(match.getId(), Collections.emptyList());
                dto.setBets(allBets.stream().map(this::toBetDtoWithoutMatch).toList());
            } else {
                // Future match: include only the current user's bet or null
                if (currentUser != null) {
                    Bet userBet = userBetByMatch.get(match.getId());
                    dto.setBets(userBet != null ? List.of(toBetDtoWithoutMatch(userBet)) : null);
                } else {
                    dto.setBets(null);
                }
            }

            result.add(dto);
        }

        return result;
    }

    private MatchV2DTO toV2DTO(Match match) {
        var mapped = matchMapper.toDTO(match);
        return MatchV2DTO.builder()
                .id(mapped.getId())
                .matchId(mapped.getMatchId())
                .footballDataMatchId(mapped.getFootballDataMatchId())
                .homeTeamId(mapped.getHomeTeamId())
                .awayTeamId(mapped.getAwayTeamId())
                .homeTeam(mapped.getHomeTeam())
                .awayTeam(mapped.getAwayTeam())
                .matchDatetime(mapped.getMatchDatetime())
                .stage(mapped.getStage())
                .homeGoals(mapped.getHomeGoals())
                .awayGoals(mapped.getAwayGoals())
                .homePenalties(mapped.getHomePenalties())
                .awayPenalties(mapped.getAwayPenalties())
                .homeOdds(mapped.getHomeOdds())
                .awayOdds(mapped.getAwayOdds())
                .drawOdds(mapped.getDrawOdds())
                .wentToExtraTime(mapped.getWentToExtraTime())
                .wentToPenalties(mapped.getWentToPenalties())
                .winnerId(mapped.getWinnerId())
                .winner(mapped.getWinner())
                .status(mapped.getStatus())
                .inProgress(match.isInProgress())
                .build();
    }

    private BetDTO toBetDtoWithoutMatch(Bet bet) {
        BetDTO dto = betMapper.toDTO(bet);
        dto.setMatch(null);
        return dto;
    }
}
