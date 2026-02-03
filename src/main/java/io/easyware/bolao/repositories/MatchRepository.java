package io.easyware.bolao.repositories;

import io.easyware.bolao.entities.Match;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.time.LocalDateTime;
import java.util.List;
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
}
