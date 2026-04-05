package io.easyware.bolao.services;

import io.easyware.bolao.dto.GroupWinnerBetDTO;
import io.easyware.bolao.dto.GroupWinnerBetRequestDTO;
import io.easyware.bolao.entities.GroupWinnerBet;
import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.mappers.GroupWinnerBetMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.GroupWinnerBetRepository;
import io.easyware.bolao.repositories.TeamRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;

import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class GroupWinnerBetService {

    @Inject
    GroupWinnerBetRepository groupWinnerBetRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    TeamRepository teamRepository;

    @Inject
    GroupWinnerBetMapper groupWinnerBetMapper;

    public List<GroupWinnerBetDTO> findAll() {
        return groupWinnerBetMapper.toDTOList(groupWinnerBetRepository.listAll());
    }

    public GroupWinnerBetDTO findById(UUID id) {
        GroupWinnerBet groupWinnerBet = groupWinnerBetRepository.findById(id);
        if (groupWinnerBet == null) {
            throw new NotFoundException("GroupWinnerBet not found with id: " + id);
        }
        return groupWinnerBetMapper.toDTO(groupWinnerBet);
    }

    public List<GroupWinnerBetDTO> findByUser(UUID userId) {
        return groupWinnerBetMapper.toDTOList(groupWinnerBetRepository.findByUser(userId));
    }

    public List<GroupWinnerBetDTO> findByGroup(GroupName groupName) {
        return groupWinnerBetMapper.toDTOList(groupWinnerBetRepository.findByGroup(groupName));
    }

    public GroupWinnerBetDTO findByUserAndGroup(UUID userId, GroupName groupName) {
        GroupWinnerBet groupWinnerBet = groupWinnerBetRepository.findByUserAndGroup(userId, groupName);
        if (groupWinnerBet == null) {
            throw new NotFoundException("GroupWinnerBet not found for user: " + userId + " and group: " + groupName);
        }
        return groupWinnerBetMapper.toDTO(groupWinnerBet);
    }

    @Transactional
    public GroupWinnerBetDTO save(GroupWinnerBetRequestDTO request) {
        GroupWinnerBet bet = groupWinnerBetRepository.findByUserAndGroup(
                request.getUserId(), request.getGroupName());

        if (bet == null) {
            bet = new GroupWinnerBet();
            var user = appUserRepository.findById(request.getUserId());
            if (user == null) {
                throw new NotFoundException("User not found: " + request.getUserId());
            }
            bet.setUser(user);
            bet.setGroupName(request.getGroupName());
        }

        var firstTeam = teamRepository.findById(request.getFirstPlaceTeamId());
        if (firstTeam == null) {
            throw new NotFoundException("Team not found: " + request.getFirstPlaceTeamId());
        }
        var secondTeam = teamRepository.findById(request.getSecondPlaceTeamId());
        if (secondTeam == null) {
            throw new NotFoundException("Team not found: " + request.getSecondPlaceTeamId());
        }

        bet.setFirstPlaceTeam(firstTeam);
        bet.setSecondPlaceTeam(secondTeam);
        groupWinnerBetRepository.persist(bet);
        return groupWinnerBetMapper.toDTO(bet);
    }

    @Transactional
    public GroupWinnerBetDTO create(GroupWinnerBetDTO groupWinnerBetDTO) {
        GroupWinnerBet groupWinnerBet = groupWinnerBetMapper.toEntity(groupWinnerBetDTO);
        groupWinnerBetRepository.persist(groupWinnerBet);
        return groupWinnerBetMapper.toDTO(groupWinnerBet);
    }

    @Transactional
    public GroupWinnerBetDTO update(UUID id, GroupWinnerBetDTO groupWinnerBetDTO) {
        GroupWinnerBet groupWinnerBet = groupWinnerBetRepository.findById(id);
        if (groupWinnerBet == null) {
            throw new NotFoundException("GroupWinnerBet not found with id: " + id);
        }
        groupWinnerBet.setGroupName(groupWinnerBetDTO.getGroupName());
        groupWinnerBet.setPointsEarned(groupWinnerBetDTO.getPointsEarned());

        if (groupWinnerBetDTO.getUserId() != null) {
            groupWinnerBet.setUser(appUserRepository.findById(groupWinnerBetDTO.getUserId()));
        }
        if (groupWinnerBetDTO.getFirstPlaceTeamId() != null) {
            groupWinnerBet.setFirstPlaceTeam(teamRepository.findById(groupWinnerBetDTO.getFirstPlaceTeamId()));
        }
        if (groupWinnerBetDTO.getSecondPlaceTeamId() != null) {
            groupWinnerBet.setSecondPlaceTeam(teamRepository.findById(groupWinnerBetDTO.getSecondPlaceTeamId()));
        }

        return groupWinnerBetMapper.toDTO(groupWinnerBet);
    }

    @Transactional
    public void delete(UUID id) {
        if (!groupWinnerBetRepository.deleteById(id)) {
            throw new NotFoundException("GroupWinnerBet not found with id: " + id);
        }
    }
}
