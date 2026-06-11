package io.easyware.bolao.dto.footballdata;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class FootballDataResponse {
    private Filters filters;
    private ResultSet resultSet;
    private Competition competition;
    private List<FootballDataMatch> matches;

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Filters {
        private String season;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResultSet {
        private Integer count;
        private String first;
        private String last;
        private Integer played;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Competition {
        private Long id;
        private String name;
        private String code;
        private String type;
        private String emblem;
    }
}
