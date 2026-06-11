package io.easyware.bolao.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationPreferenceDTO {
    private Boolean dailyEnabled;
    private Boolean eventEnabled;
}
