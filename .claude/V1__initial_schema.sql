-- Flyway Migration: V1__initial_schema.sql

-- =====================================================
-- TEAMS
-- =====================================================
CREATE TABLE team (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    fifa_code VARCHAR(3) NOT NULL UNIQUE,
    flag_url VARCHAR(255),
    group_name VARCHAR(10),
    CONSTRAINT chk_group_name CHECK (group_name IN (
        'GROUP_A', 'GROUP_B', 'GROUP_C', 'GROUP_D', 'GROUP_E', 'GROUP_F',
        'GROUP_G', 'GROUP_H', 'GROUP_I', 'GROUP_J', 'GROUP_K', 'GROUP_L'
    ))
);

CREATE INDEX idx_team_group ON team(group_name);

-- =====================================================
-- MATCHES
-- =====================================================
CREATE TABLE match (
    id BIGSERIAL PRIMARY KEY,
    home_team_id BIGINT NOT NULL,
    away_team_id BIGINT NOT NULL,
    match_datetime TIMESTAMP NOT NULL,
    stage VARCHAR(20) NOT NULL,
    home_goals INTEGER,
    away_goals INTEGER,
    went_to_extra_time BOOLEAN DEFAULT FALSE,
    went_to_penalties BOOLEAN DEFAULT FALSE,
    winner_id BIGINT,
    status VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    CONSTRAINT fk_match_home_team FOREIGN KEY (home_team_id) REFERENCES team(id),
    CONSTRAINT fk_match_away_team FOREIGN KEY (away_team_id) REFERENCES team(id),
    CONSTRAINT fk_match_winner FOREIGN KEY (winner_id) REFERENCES team(id),
    CONSTRAINT chk_match_stage CHECK (stage IN (
        'GROUP_A', 'GROUP_B', 'GROUP_C', 'GROUP_D', 'GROUP_E', 'GROUP_F',
        'GROUP_G', 'GROUP_H', 'GROUP_I', 'GROUP_J', 'GROUP_K', 'GROUP_L',
        'ROUND_OF_32', 'ROUND_OF_16', 'QUARTER_FINALS', 'SEMI_FINALS', 'FINAL'
    )),
    CONSTRAINT chk_match_status CHECK (status IN ('SCHEDULED', 'LIVE', 'FINISHED', 'CANCELLED'))
);

CREATE INDEX idx_match_datetime ON match(match_datetime);
CREATE INDEX idx_match_stage ON match(stage);
CREATE INDEX idx_match_status ON match(status);
CREATE INDEX idx_match_home_team ON match(home_team_id);
CREATE INDEX idx_match_away_team ON match(away_team_id);

-- =====================================================
-- USERS
-- =====================================================
CREATE TABLE app_user (
    id BIGSERIAL PRIMARY KEY,
    keycloak_id VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX idx_user_keycloak ON app_user(keycloak_id);
CREATE INDEX idx_user_email ON app_user(email);

-- =====================================================
-- POOLS
-- =====================================================
CREATE TABLE pool (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    entry_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    invite_code VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT chk_entry_fee CHECK (entry_fee >= 0),
    CONSTRAINT chk_currency CHECK (currency IN ('EUR', 'USD', 'BRL'))
);

CREATE UNIQUE INDEX idx_pool_invite_code ON pool(invite_code);
CREATE INDEX idx_pool_active ON pool(is_active);

-- =====================================================
-- USER POOL RELATIONSHIP
-- =====================================================
CREATE TABLE user_pool (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    pool_id BIGINT NOT NULL,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_user_pool_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_pool_pool FOREIGN KEY (pool_id) REFERENCES pool(id) ON DELETE CASCADE,
    CONSTRAINT chk_user_pool_status CHECK (status IN ('PENDING', 'ACTIVE', 'REMOVED'))
);

CREATE INDEX idx_user_pool_user ON user_pool(user_id);
CREATE INDEX idx_user_pool_pool ON user_pool(pool_id);
CREATE INDEX idx_user_pool_status ON user_pool(status);
CREATE UNIQUE INDEX idx_user_pool_unique ON user_pool(user_id, pool_id);

-- =====================================================
-- PAYMENTS
-- =====================================================
CREATE TABLE payment (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    pool_id BIGINT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    transaction_id VARCHAR(255),
    paid_at TIMESTAMP,
    confirmed_at TIMESTAMP,
    CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_pool FOREIGN KEY (pool_id) REFERENCES pool(id) ON DELETE CASCADE,
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_currency CHECK (currency IN ('EUR', 'USD', 'BRL')),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('PIX', 'CREDIT_CARD', 'BANK_TRANSFER', 'CASH', 'OTHER')),
    CONSTRAINT chk_payment_status CHECK (status IN ('PENDING', 'PAID', 'CONFIRMED', 'REJECTED', 'REFUNDED'))
);

CREATE INDEX idx_payment_user ON payment(user_id);
CREATE INDEX idx_payment_pool ON payment(pool_id);
CREATE INDEX idx_payment_status ON payment(status);

-- =====================================================
-- BETS
-- =====================================================
CREATE TABLE bet (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    match_id BIGINT NOT NULL,
    home_goals_bet INTEGER NOT NULL,
    away_goals_bet INTEGER NOT NULL,
    winner_bet_id BIGINT,
    points_earned INTEGER NOT NULL DEFAULT 0,
    bet_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bet_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_bet_match FOREIGN KEY (match_id) REFERENCES match(id) ON DELETE CASCADE,
    CONSTRAINT fk_bet_winner FOREIGN KEY (winner_bet_id) REFERENCES team(id),
    CONSTRAINT chk_bet_goals CHECK (home_goals_bet >= 0 AND away_goals_bet >= 0),
    CONSTRAINT chk_bet_points CHECK (points_earned >= 0)
);

CREATE INDEX idx_bet_user ON bet(user_id);
CREATE INDEX idx_bet_match ON bet(match_id);
CREATE UNIQUE INDEX idx_bet_user_match ON bet(user_id, match_id);

-- =====================================================
-- CHAMPION BETS
-- =====================================================
CREATE TABLE champion_bet (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    champion_team_id BIGINT,
    runner_up_team_id BIGINT,
    semifinalist1_team_id BIGINT,
    semifinalist2_team_id BIGINT,
    semifinalist3_team_id BIGINT,
    semifinalist4_team_id BIGINT,
    bet_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    bonus_points INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_champion_bet_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_champion_bet_champion FOREIGN KEY (champion_team_id) REFERENCES team(id),
    CONSTRAINT fk_champion_bet_runner_up FOREIGN KEY (runner_up_team_id) REFERENCES team(id),
    CONSTRAINT fk_champion_bet_semi1 FOREIGN KEY (semifinalist1_team_id) REFERENCES team(id),
    CONSTRAINT fk_champion_bet_semi2 FOREIGN KEY (semifinalist2_team_id) REFERENCES team(id),
    CONSTRAINT fk_champion_bet_semi3 FOREIGN KEY (semifinalist3_team_id) REFERENCES team(id),
    CONSTRAINT fk_champion_bet_semi4 FOREIGN KEY (semifinalist4_team_id) REFERENCES team(id),
    CONSTRAINT chk_champion_bonus_points CHECK (bonus_points >= 0)
);

CREATE UNIQUE INDEX idx_champion_bet_user ON champion_bet(user_id);

-- =====================================================
-- GROUP WINNER BETS
-- =====================================================
CREATE TABLE group_winner_bet (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    group_name VARCHAR(10) NOT NULL,
    first_place_team_id BIGINT NOT NULL,
    second_place_team_id BIGINT NOT NULL,
    bet_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    points_earned INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_group_winner_bet_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_group_winner_bet_first FOREIGN KEY (first_place_team_id) REFERENCES team(id),
    CONSTRAINT fk_group_winner_bet_second FOREIGN KEY (second_place_team_id) REFERENCES team(id),
    CONSTRAINT chk_group_winner_name CHECK (group_name IN (
        'GROUP_A', 'GROUP_B', 'GROUP_C', 'GROUP_D', 'GROUP_E', 'GROUP_F',
        'GROUP_G', 'GROUP_H', 'GROUP_I', 'GROUP_J', 'GROUP_K', 'GROUP_L'
    )),
    CONSTRAINT chk_group_winner_points CHECK (points_earned >= 0),
    CONSTRAINT chk_group_winner_different_teams CHECK (first_place_team_id != second_place_team_id)
);

CREATE INDEX idx_group_winner_bet_user ON group_winner_bet(user_id);
CREATE INDEX idx_group_winner_bet_group ON group_winner_bet(group_name);
CREATE UNIQUE INDEX idx_group_winner_bet_user_group ON group_winner_bet(user_id, group_name);

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE app_user IS 'Users authenticated via Keycloak';
COMMENT ON COLUMN app_user.keycloak_id IS 'UUID from Keycloak SSO';

COMMENT ON TABLE pool IS 'Betting pools/groups - users can participate in multiple pools';
COMMENT ON COLUMN pool.invite_code IS 'Unique code for users to join the pool';

COMMENT ON TABLE user_pool IS 'Many-to-many relationship between users and pools';
COMMENT ON COLUMN user_pool.status IS 'PENDING: awaiting payment, ACTIVE: can bet, REMOVED: kicked out';

COMMENT ON TABLE bet IS 'Match bets - one per user per match, shared across all pools';
COMMENT ON COLUMN bet.winner_bet_id IS 'For knockout matches that may go to penalties';

COMMENT ON TABLE champion_bet IS 'Special bets made before Round of 16 starts';

COMMENT ON TABLE group_winner_bet IS 'Predictions for 1st and 2nd place of each group';
