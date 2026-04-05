package io.easyware.bolao.dto;

import io.easyware.bolao.enums.GroupName;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupWinnerBetRequestDTO {
    private UUID userId;
    private GroupName groupName;
    private UUID firstPlaceTeamId;
    private UUID secondPlaceTeamId;
}
