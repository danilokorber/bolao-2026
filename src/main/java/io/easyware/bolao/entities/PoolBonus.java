package io.easyware.bolao.entities;

import io.easyware.bolao.enums.BonusType;
import io.easyware.bolao.enums.TournamentRound;
import io.easyware.bolao.util.UUIDv7Generator.UUIDv7;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "pool_bonus",
       uniqueConstraints = {
           @UniqueConstraint(name = "uk_pool_bonus_user_pool_type_round",
                             columnNames = {"user_id", "pool_id", "bonus_type", "tournament_round"})
       },
       indexes = {
           @Index(name = "idx_pool_bonus_pool", columnList = "pool_id"),
           @Index(name = "idx_pool_bonus_user", columnList = "user_id"),
           @Index(name = "idx_pool_bonus_round", columnList = "tournament_round")
       })
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PoolBonus {

    @Id
    @UUIDv7
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pool_id", nullable = false)
    private Pool pool;

    @Enumerated(EnumType.STRING)
    @Column(name = "bonus_type", nullable = false, length = 20)
    private BonusType bonusType;

    @Enumerated(EnumType.STRING)
    @Column(name = "tournament_round", nullable = false, length = 20)
    private TournamentRound tournamentRound;

    @Column(name = "points_earned", nullable = false)
    private Integer pointsEarned;

    @Column(name = "calculated_at", nullable = false)
    private LocalDateTime calculatedAt;
}
