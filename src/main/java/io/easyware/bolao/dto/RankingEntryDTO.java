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
    private Long countExact;
    private Long countDiff;
    private Long countWinner;
    private Long countInverted;
    private Long countWrong;
    private Long specialPoints;
    private Long totalPoints;
}
