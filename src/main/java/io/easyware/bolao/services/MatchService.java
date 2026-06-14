package io.easyware.bolao.services;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.dto.MatchDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.entities.Bet;
import io.easyware.bolao.entities.Match;
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
