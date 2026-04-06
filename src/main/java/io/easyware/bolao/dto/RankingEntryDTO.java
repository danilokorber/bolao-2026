package io.easyware.bolao.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RankingEntryDTO {
    private Integer position;
    private UUID userId;
    private String userName;
    private Long count10;
    private Long count5;
    private Long count3;
    private Long count1;
    private Long countNeg;
    private Long specialPoints;
    private Long totalPoints;
}
