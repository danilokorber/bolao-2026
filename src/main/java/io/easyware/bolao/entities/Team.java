package io.easyware.bolao.entities;

import io.easyware.bolao.enums.GroupName;
import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "team", indexes = {
    @Index(name = "idx_team_group", columnList = "group_name")
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Team {

    @Id
    @UUIDv7
    private UUID id;

    @Column(name = "name_en", nullable = false, length = 100)
    private String nameEn;

    @Column(name = "name_de", nullable = false, length = 100)
    private String nameDe;

    @Column(name = "name_pt", nullable = false, length = 100)
    private String namePt;

    @Column(name = "fifa_code", nullable = false, unique = true, length = 3)
    private String fifaCode;

    @Column(name = "flag_url", length = 255)
    private String flagUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "group_name", length = 10)
    private GroupName groupName;

    /**
     * For knockout placeholder slots (e.g. {@code WGA}, {@code RGA}), the real team
     * the slot has been resolved to. Null for real teams and unresolved slots.
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "resolved_team_id")
    private Team resolvedTeam;
}
