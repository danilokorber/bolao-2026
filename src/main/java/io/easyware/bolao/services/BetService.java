package io.easyware.bolao.services;

import io.easyware.bolao.dto.BetDTO;
import io.easyware.bolao.dto.BetRequestDTO;
import io.easyware.bolao.dto.PagedResponse;
import io.easyware.bolao.entities.AppUser;
import io.easyware.bolao.entities.Bet;
import io.easyware.bolao.mappers.BetMapper;
import io.easyware.bolao.repositories.AppUserRepository;
import io.easyware.bolao.repositories.BetRepository;
import io.easyware.bolao.repositories.MatchRepository;
import io.easyware.bolao.repositories.TeamRepository;
import io.quarkus.hibernate.orm.panache.PanacheEntity;
import io.quarkus.hibernate.orm.panache.PanacheQuery;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;
import lombok.extern.java.Log;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Log
@ApplicationScoped
public class BetService {

    @Inject
    BetRepository betRepository;

    @Inject
    AppUserRepository appUserRepository;

    @Inject
    MatchRepository matchRepository;

    @Inject
    TeamRepository teamRepository;

    @Inject
    BetMapper betMapper;

    public List<BetDTO> findAll() {
        return betMapper.toDTOList(betRepository.listAll());
    }

    public PagedResponse<BetDTO> findAll(int page, int size) {
        PanacheQuery<Bet> query = betRepository.findAll();
        query.page(page, size);
        long totalElements = query.count();
        List<BetDTO> content = betMapper.toDTOList(query.list());
        return new PagedResponse<>(content, page, size, totalElements);
    }

    public PagedResponse<BetDTO> findAll(int page, int size, String username) {
        PanacheQuery<Bet> query = betRepository.findAll();
        query.page(page, size);
        long totalElements = query.count();
        List<BetDTO> content = betMapper.toDTOList(query.list()).stream().filter(b -> b.getUser().getEmail().equalsIgnoreCase(username)).toList();
        return new PagedResponse<>(content, page, size, totalElements);
    }

    public BetDTO findById(UUID id) {
        Bet bet = betRepository.findById(id);
        if (bet == null) {
            throw new NotFoundException("Bet not found with id: " + id);
        }
        return betMapper.toDTO(bet);
    }

    public List<BetDTO> findByUser(UUID userId) {
        return betMapper.toDTOList(betRepository.findByUser(userId));
    }

    public List<BetDTO> findByMatch(UUID matchId) {
        return betMapper.toDTOList(betRepository.findByMatch(matchId));
    }

    public BetDTO findByUserAndMatch(UUID userId, UUID matchId) {
        Bet bet = betRepository.findByUserAndMatch(userId, matchId);
        if (bet == null) {
            throw new NotFoundException("Bet not found for user: " + userId + " and match: " + matchId);
        }
        return betMapper.toDTO(bet);
    }

    public List<BetDTO> findTopScorers(int limit) {
        return betMapper.toDTOList(betRepository.findTopScorers(limit));
    }

    public long getTotalPointsByUser(UUID userId) {
        return betRepository.getTotalPointsByUser(userId);
    }

    @Transactional
    public BetDTO save(BetRequestDTO request) {
        log.info("Saving bet: userId=" + request.getUserId() + ", matchId=" + request.getMatchId()
                + ", home=" + request.getHomeGoalsBet() + ", away=" + request.getAwayGoalsBet());

        var match = matchRepository.findById(request.getMatchId());
        if (match == null) {
            throw new NotFoundException("Match not found: " + request.getMatchId());
        }
        if (match.getMatchDatetime() != null && !LocalDateTime.now(ZoneOffset.UTC).isBefore(match.getMatchDatetime())) {
            throw new jakarta.ws.rs.BadRequestException("Bets cannot be placed after the match has started");
        }

        Bet bet = betRepository.findByUserAndMatch(request.getUserId(), request.getMatchId());

        if (bet == null) {
            bet = new Bet();
            var user = appUserRepository.findById(request.getUserId());
            if (user == null) {
                throw new NotFoundException("User not found: " + request.getUserId());
            }
            bet.setUser(user);
            bet.setMatch(match);
        }

        bet.setHomeGoalsBet(request.getHomeGoalsBet());
        bet.setAwayGoalsBet(request.getAwayGoalsBet());
        if (request.getWinnerBetId() != null) {
            bet.setWinnerBet(teamRepository.findById(request.getWinnerBetId()));
        }

        betRepository.persist(bet);
        return betMapper.toDTO(bet);
    }

    @Transactional
    public void delete(UUID id) {
        if (!betRepository.deleteById(id)) {
            throw new NotFoundException("Bet not found with id: " + id);
        }
    }
}
