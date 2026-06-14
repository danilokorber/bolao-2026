package io.easyware.bolao.dto;

import jakarta.json.bind.annotation.JsonbDateFormat;
import io.easyware.bolao.enums.MatchStage;
import io.easyware.bolao.enums.MatchStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
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
    private Integer footballDataMatchId;

    @NotNull
    private UUID homeTeamId;

    @NotNull
    private UUID awayTeamId;

    private TeamDTO homeTeam;
    private TeamDTO awayTeam;

    @NotNull
    @JsonbDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
    private LocalDateTime matchDatetime;

    @NotNull
    private MatchStage stage;

    @Min(0)
    private Integer homeGoals;

    @Min(0)
    private Integer awayGoals;

    private Double homeOdds;
    private Double awayOdds;
    private Double drawOdds;

    private Boolean wentToExtraTime;
    private Boolean wentToPenalties;
    private UUID winnerId;
    private TeamDTO winner;
    private MatchStatus status;
    private Boolean inProgress;
    private BetDTO userBet;
}
