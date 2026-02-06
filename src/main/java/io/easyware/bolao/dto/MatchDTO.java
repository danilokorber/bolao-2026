package io.easyware.bolao.dto;

import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MatchDTO {
    private UUID id;
    private Integer matchId;
    private UUID homeTeamId;
    private UUID awayTeamId;
    private TeamDTO homeTeam;
    private TeamDTO awayTeam;
    private LocalDateTime matchDatetime;
    private MatchStage stage;
    private Integer homeGoals;
    private Integer awayGoals;
    private Boolean wentToExtraTime;
    private Boolean wentToPenalties;
    private UUID winnerId;
    private TeamDTO winner;
    private MatchStatus status;
}
