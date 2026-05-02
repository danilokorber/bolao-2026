package io.easyware.bolao.dto;

import io.easyware.bolao.enums.Currency;
import io.easyware.bolao.enums.PaymentMethod;
import io.easyware.bolao.enums.PaymentStatus;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDTO {
    private UUID id;

    @NotNull
    private UUID userId;

    @NotNull
    private UUID poolId;

    private AppUserDTO user;
    private PoolDTO pool;

    @NotNull
    @DecimalMin("0")
    private BigDecimal amount;

    @NotNull
    private Currency currency;

    @NotNull
    private PaymentMethod paymentMethod;

    private PaymentStatus status;
    private String transactionId;
    private LocalDateTime paidAt;
    private LocalDateTime confirmedAt;
}
