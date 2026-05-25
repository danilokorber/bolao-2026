package io.easyware.bolao.services;

import io.easyware.bolao.dto.ChampionBetDTO;
import io.easyware.bolao.dto.ChampionBetRequestDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.entities.ChampionBet;
import io.easyware.bolao.mappers.ChampionBetMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.ChampionBetRepository;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;
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
    MatchRepository matchRepository;

    @Inject
    ChampionBetMapper championBetMapper;

    public List<ChampionBetDTO> findAll() {
        return championBetMapper.toDTOList(championBetRepository.listAll());
    }

    public PagedResponse<ChampionBetDTO> findAll(int page, int size) {
        PanacheQuery<ChampionBet> query = championBetRepository.findAll();
        query.page(page, size);
        long totalElements = query.count();
        List<ChampionBetDTO> content = championBetMapper.toDTOList(query.list());
        return new PagedResponse<>(content, page, size, totalElements);
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
    public ChampionBetDTO save(ChampionBetRequestDTO request) {
        // Check deadline: bets are locked once the knockout phase starts
        Optional<LocalDateTime> deadlineOpt = matchRepository.findKnockoutPhaseStart();
        if (deadlineOpt.isEmpty()) {
            throw new BadRequestException("Match schedule not yet available");
        }
        if (!LocalDateTime.now(ZoneOffset.UTC).isBefore(deadlineOpt.get())) {
            throw new BadRequestException(
                    "Champion/semifinalist betting is closed. The knockout phase has already started.");
        }

        ChampionBet bet = championBetRepository.findByUser(request.getUserId());

        if (bet == null) {
            bet = new ChampionBet();
            var user = appUserRepository.findById(request.getUserId());
            if (user == null) {
                throw new NotFoundException("User not found: " + request.getUserId());
            }
            bet.setUser(user);
        }

        if (request.getChampionTeamId() != null) {
            bet.setChampionTeam(teamRepository.findById(request.getChampionTeamId()));
        }
        if (request.getRunnerUpTeamId() != null) {
            bet.setRunnerUpTeam(teamRepository.findById(request.getRunnerUpTeamId()));
        }
        if (request.getSemifinalist1TeamId() != null) {
            bet.setSemifinalist1Team(teamRepository.findById(request.getSemifinalist1TeamId()));
        }
        if (request.getSemifinalist2TeamId() != null) {
            bet.setSemifinalist2Team(teamRepository.findById(request.getSemifinalist2TeamId()));
        }
        if (request.getSemifinalist3TeamId() != null) {
            bet.setSemifinalist3Team(teamRepository.findById(request.getSemifinalist3TeamId()));
        }
        if (request.getSemifinalist4TeamId() != null) {
            bet.setSemifinalist4Team(teamRepository.findById(request.getSemifinalist4TeamId()));
        }

        championBetRepository.persist(bet);
        return championBetMapper.toDTO(bet);
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

    /**
     * Returns the deadline for champion/semifinalist bets.
     * The deadline is the start of the first knockout-phase match (Round of 32).
     *
     * @return the deadline datetime, or empty if no knockout matches exist yet
     */
    public Optional<LocalDateTime> getDeadline() {
        return matchRepository.findKnockoutPhaseStart();
    }
}
