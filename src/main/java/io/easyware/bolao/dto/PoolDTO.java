package io.easyware.bolao.dto;

import io.easyware.bolao.enums.Currency;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
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

    @NotBlank
    @Size(max = 100)
    private String name;

    private String description;

    @NotNull
    @DecimalMin("0")
    private BigDecimal entryFee;

    @NotNull
    private Currency currency;

    private LocalDateTime createdAt;
    private Boolean isActive;
    private String inviteCode;
}
