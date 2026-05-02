package io.easyware.bolao.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BetRequestDTO {
    private UUID id;

    @NotNull
    private UUID userId;

    @NotNull
    private UUID matchId;

    @NotNull
    @Min(0)
    private Integer homeGoalsBet;

    @NotNull
    @Min(0)
    private Integer awayGoalsBet;

    private UUID winnerBetId;
}
