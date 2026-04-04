package io.easyware.bolao.dto;

import io.easyware.bolao.enums.GroupName;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupWinnerBetDTO {
    private UUID id;
    private UUID userId;
    private AppUserDTO user;
    private GroupName groupName;
    private UUID firstPlaceTeamId;
    private TeamDTO firstPlaceTeam;
    private UUID secondPlaceTeamId;
    private TeamDTO secondPlaceTeam;
    private LocalDateTime betAt;
    private Integer pointsEarned;
    private Integer calculatedPoints;
}
