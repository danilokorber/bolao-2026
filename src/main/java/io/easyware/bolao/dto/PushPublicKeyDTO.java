package io.easyware.bolao.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PushPublicKeyDTO {
    private String publicKey;
    private Boolean enabled;
}
