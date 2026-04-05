package io.easyware.bolao.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChampionBetRequestDTO {
    private UUID userId;
    private UUID championTeamId;
    private UUID runnerUpTeamId;
    private UUID semifinalist1TeamId;
    private UUID semifinalist2TeamId;
    private UUID semifinalist3TeamId;
    private UUID semifinalist4TeamId;
}
