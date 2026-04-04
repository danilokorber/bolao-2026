package io.easyware.bolao.services;

import io.easyware.bolao.dto.ChampionBetDTO;
import io.easyware.bolao.entities.ChampionBet;
import io.easyware.bolao.mappers.ChampionBetMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.ChampionBetRepository;
import io.easyware.bolao.repositories.TeamRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class ChampionBetService {

    @Inject
    ChampionBetRepository championBetRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    TeamRepository teamRepository;

    @Inject
    ChampionBetMapper championBetMapper;

    public List<ChampionBetDTO> findAll() {
        return championBetMapper.toDTOList(championBetRepository.listAll());
    }

    public ChampionBetDTO findById(UUID id) {
        ChampionBet championBet = championBetRepository.findById(id);
        if (championBet == null) {
            throw new NotFoundException("ChampionBet not found with id: " + id);
        }
        return championBetMapper.toDTO(championBet);
    }

    public ChampionBetDTO findByUser(UUID userId) {
        ChampionBet championBet = championBetRepository.findByUser(userId);
        if (championBet == null) {
            throw new NotFoundException("ChampionBet not found for user: " + userId);
        }
        return championBetMapper.toDTO(championBet);
    }

    public long countByChampionTeam(UUID teamId) {
        return championBetRepository.countByChampionTeam(teamId);
    }

    public long countByRunnerUpTeam(UUID teamId) {
        return championBetRepository.countByRunnerUpTeam(teamId);
    }

    @Transactional
    public ChampionBetDTO create(ChampionBetDTO championBetDTO) {
        ChampionBet championBet = championBetMapper.toEntity(championBetDTO);
        championBetRepository.persist(championBet);
        return championBetMapper.toDTO(championBet);
    }

    @Transactional
    public ChampionBetDTO update(UUID id, ChampionBetDTO championBetDTO) {
        ChampionBet championBet = championBetRepository.findById(id);
        if (championBet == null) {
            throw new NotFoundException("ChampionBet not found with id: " + id);
        }
        championBet.setBonusPoints(championBetDTO.getBonusPoints());

        if (championBetDTO.getUserId() != null) {
            championBet.setUser(appUserRepository.findById(championBetDTO.getUserId()));
        }
        if (championBetDTO.getChampionTeamId() != null) {
            championBet.setChampionTeam(teamRepository.findById(championBetDTO.getChampionTeamId()));
        }
        if (championBetDTO.getRunnerUpTeamId() != null) {
            championBet.setRunnerUpTeam(teamRepository.findById(championBetDTO.getRunnerUpTeamId()));
        }
        if (championBetDTO.getSemifinalist1TeamId() != null) {
            championBet.setSemifinalist1Team(teamRepository.findById(championBetDTO.getSemifinalist1TeamId()));
        }
        if (championBetDTO.getSemifinalist2TeamId() != null) {
            championBet.setSemifinalist2Team(teamRepository.findById(championBetDTO.getSemifinalist2TeamId()));
        }
        if (championBetDTO.getSemifinalist3TeamId() != null) {
            championBet.setSemifinalist3Team(teamRepository.findById(championBetDTO.getSemifinalist3TeamId()));
        }
        if (championBetDTO.getSemifinalist4TeamId() != null) {
            championBet.setSemifinalist4Team(teamRepository.findById(championBetDTO.getSemifinalist4TeamId()));
        }

        return championBetMapper.toDTO(championBet);
    }

    @Transactional
    public void delete(UUID id) {
        if (!championBetRepository.deleteById(id)) {
            throw new NotFoundException("ChampionBet not found with id: " + id);
        }
    }
}
