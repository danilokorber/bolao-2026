package io.easyware.bolao.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppUserDTO {
    private UUID id;
    private String keycloakId;
    private String name;
    private String email;
    private LocalDateTime createdAt;
    private Boolean active;
}
