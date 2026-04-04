package io.easyware.bolao.dto;

import io.easyware.bolao.enums.GroupName;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamDTO {
    private UUID id;
    private String nameEn;
    private String nameDe;
    private String namePt;
    private String fifaCode;
    private String flagUrl;
    private GroupName groupName;
}
