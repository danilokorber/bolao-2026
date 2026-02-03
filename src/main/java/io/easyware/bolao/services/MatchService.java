package io.easyware.bolao.services;

import io.easyware.bolao.dto.MatchDTO;
import io.easyware.bolao.entities.Match;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.mappers.MatchMapper;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class MatchService {

    @Inject
    MatchRepository matchRepository;

    @Inject
    TeamRepository teamRepository;

    @Inject
    MatchMapper matchMapper;

    public List<MatchDTO> findAll() {
            return matchMapper.toDTOList(
                matchRepository.listAll()
                    .stream()
                    .sorted((m1, m2) -> m1.getMatchDatetime().compareTo(m2.getMatchDatetime()))
                    .toList()
            );
        }

    public MatchDTO findById(UUID id) {
        Match match = matchRepository.findById(id);
        if (match == null) {
            throw new NotFoundException("Match not found with id: " + id);
        }
        return matchMapper.toDTO(match);
    }

    public List<MatchDTO> findByStage(MatchStage stage) {
        return matchMapper.toDTOList(matchRepository.findByStage(stage));
    }

    public List<MatchDTO> findByStatus(MatchStatus status) {
        return matchMapper.toDTOList(matchRepository.findByStatus(status));
    }

    public List<MatchDTO> findByTeam(UUID teamId) {
        return matchMapper.toDTOList(matchRepository.findByTeam(teamId));
    }

    public List<MatchDTO> findUpcoming(int next) {
        return matchMapper.toDTOList(matchRepository.findUpcoming(next));
    }

    public List<MatchDTO> findByDateRange(LocalDateTime start, LocalDateTime end) {
        return matchMapper.toDTOList(matchRepository.findByDateRange(start, end));
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
}
