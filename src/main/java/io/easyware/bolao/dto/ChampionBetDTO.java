package io.easyware.bolao.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChampionBetDTO {
    private UUID id;
    private UUID userId;
    private AppUserDTO user;
    private UUID championTeamId;
    private TeamDTO championTeam;
    private UUID runnerUpTeamId;
    private TeamDTO runnerUpTeam;
    private UUID semifinalist1TeamId;
    private TeamDTO semifinalist1Team;
    private UUID semifinalist2TeamId;
    private TeamDTO semifinalist2Team;
    private UUID semifinalist3TeamId;
    private TeamDTO semifinalist3Team;
    private UUID semifinalist4TeamId;
    private TeamDTO semifinalist4Team;
    private LocalDateTime betAt;
    private Integer bonusPoints;
    private Integer calculatedPoints;
}
