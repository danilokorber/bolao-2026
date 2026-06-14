package io.easyware.bolao.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FavoriteToggleResponseDTO {
    private UUID userId;
    private UUID favoriteUserId;
    private Boolean favorite;
}
