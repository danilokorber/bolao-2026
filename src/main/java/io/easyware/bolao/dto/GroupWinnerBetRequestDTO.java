package io.easyware.bolao.dto;

import io.easyware.bolao.enums.GroupName;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupWinnerBetRequestDTO {
    @NotNull
    private UUID userId;

    @NotNull
    private GroupName groupName;

    @NotNull
    private UUID firstPlaceTeamId;

    @NotNull
    private UUID secondPlaceTeamId;
}
