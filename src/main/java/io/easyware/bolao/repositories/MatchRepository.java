package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.Match;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@ApplicationScoped
public class MatchRepository implements PanacheRepositoryBase<Match, UUID> {

    public List<Match> findByStage(MatchStage stage) {
        return list("stage", stage);
    }

    public List<Match> findByStatus(MatchStatus status) {
        return list("status", status);
    }

    public List<Match> findByTeam(UUID teamId) {
        return list("homeTeam.id = ?1 or awayTeam.id = ?1", teamId);
    }

    public List<Match> findUpcoming(int next) {
        return find("matchDatetime > ?1 and status = ?2 order by matchDatetime",
                    LocalDateTime.now(), MatchStatus.SCHEDULED)
                .page(0, next)
                .list();
    }

    public List<Match> findByDateRange(LocalDateTime start, LocalDateTime end) {
        return list("matchDatetime between ?1 and ?2 order by matchDatetime", start, end);
    }

    /**
     * Finds all finished matches for a given group stage (e.g. GROUP_A).
     *
     * @param stage the group stage to query
     * @return finished matches in that group
     */
    public List<Match> findFinishedByStage(MatchStage stage) {
        return list("stage = ?1 and status = ?2", stage, MatchStatus.FINISHED);
    }

    /**
     * Checks whether all matches in a given group stage are finished.
     *
     * @param stage the group stage to check
     * @return true if every match in the group has status FINISHED
     */
    public boolean isGroupComplete(MatchStage stage) {
        long total = count("stage", stage);
        long finished = count("stage = ?1 and status = ?2", stage, MatchStatus.FINISHED);
        return total > 0 && total == finished;
    }

    /**
     * Checks whether all matches in a given group stage are finished AND in the past.
     * This prevents scoring group winner bets for groups whose matches have future kickoff times
     * (e.g. during testing with seeded data).
     *
     * @param stage the group stage to check
     * @param now   the current UTC timestamp
     * @return true if every match in the group has status FINISHED and matchDatetime &lt; now
     */
    public boolean isGroupCompleteAndPast(MatchStage stage, LocalDateTime now) {
        long total = count("stage", stage);
        long finishedAndPast = count("stage = ?1 and status = ?2 and matchDatetime < ?3",
                                     stage, MatchStatus.FINISHED, now);
        return total > 0 && total == finishedAndPast;
    }

    /**
     * Finds the start datetime of the second matchday for a given group stage.
     * In a group of 4 teams with 6 matches across 3 matchdays (2 matches each),
     * the second matchday starts with the 3rd match when sorted chronologically.
     *
     * @param stage the group stage (e.g. GROUP_A)
     * @return the datetime of the first match on the second matchday, or empty if fewer than 3 matches
     */
    public Optional<LocalDateTime> findSecondMatchdayStart(MatchStage stage) {
        List<Match> matches = find("stage = ?1 order by matchDatetime asc", stage)
                .page(0, 3)
                .list();
        if (matches.size() < 3) {
            return Optional.empty();
        }
        return Optional.of(matches.get(2).getMatchDatetime());
    }

    /**
     * Finds the datetime of the first knockout-phase match (ROUND_OF_32).
     * This is the deadline for champion/semifinalist bets.
     *
     * @return the datetime of the earliest Round of 32 match, or empty if no matches exist
     */
    public Optional<LocalDateTime> findKnockoutPhaseStart() {
        List<Match> matches = find("stage = ?1 order by matchDatetime asc", MatchStage.ROUND_OF_32)
                .page(0, 1)
                .list();
        if (matches.isEmpty()) {
            return Optional.empty();
        }
        return Optional.of(matches.get(0).getMatchDatetime());
    }

    /**
     * Finds matches that should be polled for updates from the external API.
     * A match is pollable if it is:
     * <ul>
     *   <li>Currently LIVE (in progress)</li>
     *   <li>SCHEDULED and starting within the next 15 minutes</li>
     * </ul>
     *
     * @return list of matches that need polling
     */
    public List<Match> findPollableMatches() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime soon = now.plusMinutes(15);
        return find("status = ?1 or (status = ?2 and matchDatetime between ?3 and ?4)",
                MatchStatus.LIVE, MatchStatus.SCHEDULED, now, soon)
                .list();
    }
}
