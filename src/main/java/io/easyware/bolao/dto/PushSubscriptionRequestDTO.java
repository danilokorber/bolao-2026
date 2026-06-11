package io.easyware.bolao.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PushSubscriptionRequestDTO {
    @NotBlank
    private String endpoint;

    @NotBlank
    private String p256dhKey;

    @NotBlank
    private String authKey;

    private String userAgent;
}
