package io.easyware.bolao.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FavoriteToggleResponseDTO {

    private UUID userId;
    private UUID favoriteUserId;
    private Boolean isFavorite;
}