package io.easyware.bolao.dto;

import io.easyware.bolao.enums.UserPoolStatus;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserPoolDTO {
    private UUID id;
    private UUID userId;
    private UUID poolId;
    private AppUserDTO user;
    private PoolDTO pool;
    private LocalDateTime joinedAt;
    private UserPoolStatus status;
}
