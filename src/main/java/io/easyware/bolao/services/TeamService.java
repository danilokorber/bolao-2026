package io.easyware.bolao.services;

import io.easyware.bolao.dto.TeamDTO;
import io.easyware.bolao.entities.Team;
import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.mappers.TeamMapper;
import io.easyware.bolao.repositories.TeamRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class TeamService {

    @Inject
    TeamRepository teamRepository;

    @Inject
    TeamMapper teamMapper;

    public List<TeamDTO> findAll() {
        return teamMapper.toDTOList(teamRepository.listAll());
    }

    public TeamDTO findById(UUID id) {
        Team team = teamRepository.findById(id);
        if (team == null) {
            throw new NotFoundException("Team not found with id: " + id);
        }
        return teamMapper.toDTO(team);
    }

    public TeamDTO findByFifaCode(String fifaCode) {
        Team team = teamRepository.findByFifaCode(fifaCode);
        if (team == null) {
            throw new NotFoundException("Team not found with FIFA code: " + fifaCode);
        }
        return teamMapper.toDTO(team);
    }

    public List<TeamDTO> findByGroup(GroupName groupName) {
        return teamMapper.toDTOList(teamRepository.findByGroup(groupName));
    }

    @Transactional
    public TeamDTO create(TeamDTO teamDTO) {
        Team team = teamMapper.toEntity(teamDTO);
        teamRepository.persist(team);
        return teamMapper.toDTO(team);
    }

    @Transactional
    public TeamDTO update(UUID id, TeamDTO teamDTO) {
        Team team = teamRepository.findById(id);
        if (team == null) {
            throw new NotFoundException("Team not found with id: " + id);
        }
        team.setNameEn(teamDTO.getNameEn());
        team.setNameDe(teamDTO.getNameDe());
        team.setNamePt(teamDTO.getNamePt());
        team.setFifaCode(teamDTO.getFifaCode());
        team.setFlagUrl(teamDTO.getFlagUrl());
        team.setGroupName(teamDTO.getGroupName());
        return teamMapper.toDTO(team);
    }

    @Transactional
    public void delete(UUID id) {
        if (!teamRepository.deleteById(id)) {
            throw new NotFoundException("Team not found with id: " + id);
        }
    }
}
