package io.easyware.bolao.dto;

import io.easyware.bolao.enums.Currency;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PoolDTO {
    private UUID id;
    private String name;
    private String description;
    private BigDecimal entryFee;
    private Currency currency;
    private LocalDateTime createdAt;
    private Boolean isActive;
    private String inviteCode;
}
