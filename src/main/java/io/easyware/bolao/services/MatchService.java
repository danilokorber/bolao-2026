package io.easyware.bolao.services;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.dto.MatchDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.entities.Bet;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.mappers.BetMapper;
import io.easyware.bolao.mappers.MatchMapper;
import io.easyware.bolao.repositories.BetRepository;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import io.quarkus.panache.common.Sort;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@ApplicationScoped
public class MatchService {

    @Inject
    MatchRepository matchRepository;

    @Inject
    TeamRepository teamRepository;

    @Inject
    BetRepository betRepository;

    @Inject
    MatchMapper matchMapper;

    @Inject
    BetMapper betMapper;

    @Inject
    ScoreCalculationService scoreCalculationService;

    public List<MatchDTO> findAll(UUID userId) {
        List<MatchDTO> dtos = matchMapper.toDTOList(
            matchRepository.listAll()
                .stream()
                .sorted((m1, m2) -> m1.getMatchDatetime().compareTo(m2.getMatchDatetime()))
                .toList()
        );
        return enrichWithUserBets(dtos, userId);
    }

    public PagedResponse<MatchDTO> findAll(int page, int size, UUID userId) {
        PanacheQuery<Match> query = matchRepository.findAll(Sort.by("matchDatetime"));
        query.page(page, size);
        long totalElements = query.count();
        List<MatchDTO> content = enrichWithUserBets(matchMapper.toDTOList(query.list()), userId);
        return new PagedResponse<>(content, page, size, totalElements);
    }

    public MatchDTO findById(UUID id, UUID userId) {
        Match match = matchRepository.findById(id);
        if (match == null) {
            throw new NotFoundException("Match not found with id: " + id);
        }
        MatchDTO dto = matchMapper.toDTO(match);
        return enrichWithUserBet(dto, userId);
    }

    public List<MatchDTO> findByStage(MatchStage stage, UUID userId) {
        List<MatchDTO> dtos = matchMapper.toDTOList(matchRepository.findByStage(stage));
        return enrichWithUserBets(dtos, userId);
    }

    public List<MatchDTO> findByStatus(MatchStatus status, UUID userId) {
        List<MatchDTO> dtos = matchMapper.toDTOList(matchRepository.findByStatus(status));
        return enrichWithUserBets(dtos, userId);
    }

    public List<MatchDTO> findByTeam(UUID teamId, UUID userId) {
        List<MatchDTO> dtos = matchMapper.toDTOList(matchRepository.findByTeam(teamId));
        return enrichWithUserBets(dtos, userId);
    }

    public List<MatchDTO> findUpcoming(int next, UUID userId) {
        List<MatchDTO> dtos = matchMapper.toDTOList(matchRepository.findUpcoming(next));
        return enrichWithUserBets(dtos, userId);
    }

    public List<MatchDTO> findByDateRange(LocalDateTime start, LocalDateTime end, UUID userId) {
        List<MatchDTO> dtos = matchMapper.toDTOList(matchRepository.findByDateRange(start, end));
        return enrichWithUserBets(dtos, userId);
    }

    @Transactional
    public MatchDTO create(MatchDTO matchDTO) {
        Match match = matchMapper.toEntity(matchDTO);
        matchRepository.persist(match);
        return matchMapper.toDTO(match);
    }

    @Transactional
    public MatchDTO update(UUID id, MatchDTO matchDTO) {
        Match match = matchRepository.findById(id);
        if (match == null) {
            throw new NotFoundException("Match not found with id: " + id);
        }
        match.setMatchDatetime(matchDTO.getMatchDatetime());
        match.setStage(matchDTO.getStage());
        match.setHomeGoals(matchDTO.getHomeGoals());
        match.setAwayGoals(matchDTO.getAwayGoals());
        match.setHomeOdds(matchDTO.getHomeOdds());
        match.setAwayOdds(matchDTO.getAwayOdds());
        match.setDrawOdds(matchDTO.getDrawOdds());
        match.setWentToExtraTime(matchDTO.getWentToExtraTime());
        match.setWentToPenalties(matchDTO.getWentToPenalties());
        match.setStatus(matchDTO.getStatus());

        if (matchDTO.getHomeTeamId() != null) {
            match.setHomeTeam(teamRepository.findById(matchDTO.getHomeTeamId()));
        }
        if (matchDTO.getAwayTeamId() != null) {
            match.setAwayTeam(teamRepository.findById(matchDTO.getAwayTeamId()));
        }
        if (matchDTO.getWinnerId() != null) {
            match.setWinner(teamRepository.findById(matchDTO.getWinnerId()));
        }

        return matchMapper.toDTO(match);
    }

    /**
     * Resolves a knockout-phase slot placeholder to a real team.
     * <p>
     * Looks up the placeholder team by its synthetic slot code and the real qualifier
     * by its fifa code, then re-points every match FK (home/away/winner) that currently
     * references the placeholder to the real team row. This avoids mutating the
     * placeholder's fifa code, which would violate the unique constraint on
     * {@code team.fifa_code}.
     *
     * @param slotCode synthetic fifa code of the placeholder slot (e.g. {@code WGA})
     * @param fifaCode real fifa code of the qualified team (e.g. {@code MEX})
     * @return the number of matches updated
     */
    @Transactional
    public int resolveSlot(String slotCode, String fifaCode) {
        Team placeholder = teamRepository.findByFifaCode(slotCode);
        if (placeholder == null) {
            throw new NotFoundException("Placeholder slot not found with fifa code: " + slotCode);
        }
        Team realTeam = teamRepository.findByFifaCode(fifaCode);
        if (realTeam == null) {
            throw new NotFoundException("Team not found with fifa code: " + fifaCode);
        }

        UUID placeholderId = placeholder.getId();
        List<Match> matches = matchRepository.findByTeamIncludingWinner(placeholderId);
        int updated = 0;
        for (Match match : matches) {
            boolean changed = false;
            if (match.getHomeTeam() != null && placeholderId.equals(match.getHomeTeam().getId())) {
                match.setHomeTeam(realTeam);
                changed = true;
            }
            if (match.getAwayTeam() != null && placeholderId.equals(match.getAwayTeam().getId())) {
                match.setAwayTeam(realTeam);
                changed = true;
            }
            if (match.getWinner() != null && placeholderId.equals(match.getWinner().getId())) {
                match.setWinner(realTeam);
                changed = true;
            }
            if (changed) {
                updated++;
            }
        }

        // Persist the slot -> real team mapping so group scoring can read both the
        // winner (WG{x}) and runner-up (RG{x}) regardless of resolution order.
        placeholder.setResolvedTeam(realTeam);

        // When a group winner/runner-up slot is resolved, the admin decision is the
        // authoritative source of 1st/2nd place (it applies FIFA tiebreakers). Score
        // the affected group's winner bets immediately.
        if (slotCode.matches("^(WG|RG)[A-L]$")) {
            String letter = slotCode.substring(2);
            GroupName groupName = GroupName.valueOf("GROUP_" + letter);
            scoreCalculationService.scoreGroupWinnerBetsFromResolvedSlots(groupName);
        }

        return updated;
    }

    @Transactional
    public void delete(UUID id) {
        if (!matchRepository.deleteById(id)) {
            throw new NotFoundException("Match not found with id: " + id);
        }
    }

    private MatchDTO enrichWithUserBet(MatchDTO dto, UUID userId) {
        if (userId == null) {
            dto.setUserBet(new BetDTO());
            return dto;
        }
        Bet bet = betRepository.findByUserAndMatch(userId, dto.getId());
        dto.setUserBet(bet != null ? toBetDtoWithoutMatch(bet) : new BetDTO());
        return dto;
    }

    private List<MatchDTO> enrichWithUserBets(List<MatchDTO> dtos, UUID userId) {
        if (userId == null) {
            dtos.forEach(d -> d.setUserBet(new BetDTO()));
            return dtos;
        }
        List<Bet> userBets = betRepository.findByUser(userId);
        Map<UUID, Bet> betByMatch = userBets.stream()
            .collect(Collectors.toMap(b -> b.getMatch().getId(), b -> b, (a, b) -> a));
        for (MatchDTO dto : dtos) {
            Bet bet = betByMatch.get(dto.getId());
            dto.setUserBet(bet != null ? toBetDtoWithoutMatch(bet) : new BetDTO());
        }
        return dtos;
    }

    private BetDTO toBetDtoWithoutMatch(Bet bet) {
        BetDTO dto = betMapper.toDTO(bet);
        dto.setMatch(null);
        return dto;
    }
}
