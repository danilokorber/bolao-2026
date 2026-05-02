-- Pool bonuses: round bonuses (best predictor / top 3) and recovery bonuses.
-- One row per user+pool+bonus_type+round, idempotent via unique constraint.
CREATE TABLE pool_bonus (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES app_user(id),
    pool_id UUID NOT NULL REFERENCES pool(id),
    bonus_type VARCHAR(20) NOT NULL,
    tournament_round VARCHAR(20) NOT NULL,
    points_earned INTEGER NOT NULL CHECK (points_earned >= 0),
    calculated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT uk_pool_bonus_user_pool_type_round
        UNIQUE (user_id, pool_id, bonus_type, tournament_round)
);

CREATE INDEX idx_pool_bonus_pool ON pool_bonus(pool_id);
CREATE INDEX idx_pool_bonus_user ON pool_bonus(user_id);
CREATE INDEX idx_pool_bonus_round ON pool_bonus(tournament_round);
