package io.easyware.bolao.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BetRequestDTO {
    private UUID id;
    private UUID userId;
    private UUID matchId;
    private Integer homeGoalsBet;
    private Integer awayGoalsBet;
    private UUID winnerBetId;
}
