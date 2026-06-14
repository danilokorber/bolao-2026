package io.easyware.bolao.dto;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FavoriteToggleRequestDTO {
    @NotNull
    private UUID userId;
}
