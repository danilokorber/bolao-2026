package io.easyware.bolao.dto;

import io.easyware.bolao.enums.ScoreTier;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BetDTO {
    private UUID id;
    private UUID userId;
    private UUID matchId;
    private AppUserDTO user;
    private MatchDTO match;
    private Integer homeGoalsBet;
    private Integer awayGoalsBet;
    private UUID winnerBetId;
    private TeamDTO winnerBet;
    private Integer pointsEarned;
    private Integer calculatedPoints;
    private ScoreTier scoreTier;
    private LocalDateTime betAt;
}
