package io.easyware.bolao.dto.footballdata;

import lombok.*;

import java.time.OffsetDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class FootballDataMatch {
    private Area area;
    private Competition competition;
    private Season season;
    private Long id;
    private OffsetDateTime utcDate;
    private String status;
    private String venue;
    private Integer matchday;
    private String stage;
    private String group;
    private OffsetDateTime lastUpdated;
    private Team homeTeam;
    private Team awayTeam;
    private Score score;
    private Odds odds;
    private List<Referee> referees;

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Area {
        private Long id;
        private String name;
        private String code;
        private String flag;
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

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Season {
        private Long id;
        private String startDate;
        private String endDate;
        private Integer currentMatchday;
        private String winner;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Team {
        private Long id;
        private String name;
        private String shortName;
        private String tla;
        private String crest;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Score {
        private String winner;
        private String duration;
        private TimeScore fullTime;
        private TimeScore halfTime;
        private TimeScore regularTime;
        private TimeScore extraTime;
        private TimeScore penalties;

        @Getter
        @Setter
        @Builder
        @NoArgsConstructor
        @AllArgsConstructor
        public static class TimeScore {
            private Integer home;
            private Integer away;
        }
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Odds {
        private String msg;
    }

    @Getter
    @Setter
    @Builder
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Referee {
        private Long id;
        private String name;
        private String type;
        private String nationality;
    }
}
