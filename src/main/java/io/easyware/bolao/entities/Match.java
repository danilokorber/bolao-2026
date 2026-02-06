package io.easyware.bolao.entities;

import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "match", indexes = {
    @Index(name = "idx_match_datetime", columnList = "match_datetime"),
    @Index(name = "idx_match_stage", columnList = "stage"),
    @Index(name = "idx_match_status", columnList = "status"),
    @Index(name = "idx_match_home_team", columnList = "home_team_id"),
    @Index(name = "idx_match_away_team", columnList = "away_team_id"),
    @Index(name = "idx_match_match_id", columnList = "match_id")
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Match {

    @Id
    @UUIDv7
    private UUID id;

    @Column(name = "match_id", unique = true)
    private Integer matchId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "home_team_id", nullable = false)
    private Team homeTeam;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "away_team_id", nullable = false)
    private Team awayTeam;

    @Column(name = "match_datetime", nullable = false)
    private LocalDateTime matchDatetime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private MatchStage stage;

    @Column(name = "home_goals")
    private Integer homeGoals;

    @Column(name = "away_goals")
    private Integer awayGoals;

    @Column(name = "went_to_extra_time")
    @Builder.Default
    private Boolean wentToExtraTime = false;

    @Column(name = "went_to_penalties")
    @Builder.Default
    private Boolean wentToPenalties = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "winner_id")
    private Team winner;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private MatchStatus status = MatchStatus.SCHEDULED;
}
