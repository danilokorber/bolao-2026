-- Flyway Migration: V2026.0.0.6__mock_knockout_results_and_bets.sql
-- =====================================================
-- Purpose: Complete the World Cup 2026 mock data:
--   1. Assign real teams and results to knockout matches 73-104
--   2. Add 3 additional mock users
--   3. Insert bets for existing mock user (knockout matches 73-104)
--   4. Insert bets for 3 new users (all 104 matches)
-- Engine : PostgreSQL (uuid-ossp required)
-- =====================================================

-- =====================================================
-- SECTION 1: Update knockout matches with real teams and results
-- =====================================================

-- Round of 32
UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'KOR'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'SUI'),
    home_goals = 0,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 73;  -- KOR 0-1 SUI

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'BRA'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'CZE'),
    home_goals = 3,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 74;  -- BRA 3-0 CZE

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'GER'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'IRQ'),
    home_goals = 4,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 75;  -- GER 4-1 IRQ

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'NED'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'MAR'),
    home_goals = 2,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 76;  -- NED 2-1 MAR

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'CIV'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'SEN'),
    home_goals = 1,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 77;  -- CIV 1-2 SEN

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'FRA'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'JPN'),
    home_goals = 2,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 78;  -- FRA 2-0 JPN

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'MEX'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'IRN'),
    home_goals = 1,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 79;  -- MEX 1-0 IRN

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'ENG'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'GHA'),
    home_goals = 3,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 80;  -- ENG 3-1 GHA

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'BEL'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ECU'),
    home_goals = 2,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 81;  -- BEL 2-0 ECU

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'USA'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'AUS'),
    home_goals = 2,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 82;  -- USA 2-1 AUS

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'ESP'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'AUT'),
    home_goals = 3,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 83;  -- ESP 3-0 AUT

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'COD'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'PAN'),
    home_goals = 0,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = TRUE,
    went_to_penalties = TRUE,
    winner_id = (SELECT id FROM team WHERE fifa_code = 'COD')
WHERE match_id = 84;  -- COD 0-0 PAN (pen: COD)

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'CAN'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'BIH'),
    home_goals = 1,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = TRUE,
    went_to_penalties = TRUE,
    winner_id = (SELECT id FROM team WHERE fifa_code = 'CAN')
WHERE match_id = 85;  -- CAN 1-1 BIH (pen: CAN)

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'TUR'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'EGY'),
    home_goals = 2,
    away_goals = 3,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 86;  -- TUR 2-3 EGY

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'ARG'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'CPV'),
    home_goals = 4,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 87;  -- ARG 4-0 CPV

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'POR'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'SWE'),
    home_goals = 2,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 88;  -- POR 2-1 SWE

-- Round of 16
UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'SUI'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'GER'),
    home_goals = 1,
    away_goals = 3,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 89;  -- SUI 1-3 GER

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'BRA'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'SEN'),
    home_goals = 2,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 90;  -- BRA 2-0 SEN

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'NED'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'FRA'),
    home_goals = 1,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 91;  -- NED 1-2 FRA

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'MEX'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ENG'),
    home_goals = 0,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 92;  -- MEX 0-2 ENG

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'ESP'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'COD'),
    home_goals = 3,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 93;  -- ESP 3-0 COD

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'BEL'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'USA'),
    home_goals = 1,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 94;  -- BEL 1-2 USA

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'CAN'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'POR'),
    home_goals = 0,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 95;  -- CAN 0-1 POR

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'EGY'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ARG'),
    home_goals = 0,
    away_goals = 3,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 96;  -- EGY 0-3 ARG

-- Quarter-finals
UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'GER'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'BRA'),
    home_goals = 2,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = TRUE,
    went_to_penalties = TRUE,
    winner_id = (SELECT id FROM team WHERE fifa_code = 'GER')
WHERE match_id = 97;  -- GER 2-2 BRA (pen: GER)

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'ESP'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'USA'),
    home_goals = 1,
    away_goals = 0,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 98;  -- ESP 1-0 USA

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'FRA'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ENG'),
    home_goals = 2,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 99;  -- FRA 2-1 ENG

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'POR'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ARG'),
    home_goals = 1,
    away_goals = 3,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 100;  -- POR 1-3 ARG

-- Semi-finals
UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'GER'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ESP'),
    home_goals = 1,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 101;  -- GER 1-2 ESP

UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'FRA'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ARG'),
    home_goals = 2,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = TRUE,
    went_to_penalties = TRUE,
    winner_id = (SELECT id FROM team WHERE fifa_code = 'ARG')
WHERE match_id = 102;  -- FRA 2-2 ARG (pen: ARG)

-- Third place
UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'GER'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'FRA'),
    home_goals = 3,
    away_goals = 2,
    status = 'FINISHED',
    went_to_extra_time = FALSE,
    went_to_penalties = FALSE,
    winner_id = NULL
WHERE match_id = 103;  -- GER 3-2 FRA

-- Final
UPDATE match SET
    home_team_id = (SELECT id FROM team WHERE fifa_code = 'ESP'),
    away_team_id = (SELECT id FROM team WHERE fifa_code = 'ARG'),
    home_goals = 1,
    away_goals = 1,
    status = 'FINISHED',
    went_to_extra_time = TRUE,
    went_to_penalties = TRUE,
    winner_id = (SELECT id FROM team WHERE fifa_code = 'ARG')
WHERE match_id = 104;  -- ESP 1-1 ARG (pen: ARG)


-- =====================================================
-- SECTION 2: Add 3 additional mock users
-- =====================================================

INSERT INTO app_user (id, keycloak_id, name, email, created_at, active)
VALUES ('019d59db-4f87-7fe8-0001-000000000001', 'mock-keycloak-ana', 'Ana Silva', 'ana@bolao.test', CURRENT_TIMESTAMP, TRUE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO app_user (id, keycloak_id, name, email, created_at, active)
VALUES ('019d59db-4f87-7fe8-0002-000000000002', 'mock-keycloak-max', 'Max Müller', 'max@bolao.test', CURRENT_TIMESTAMP, TRUE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO app_user (id, keycloak_id, name, email, created_at, active)
VALUES ('019d59db-4f87-7fe8-0003-000000000003', 'mock-keycloak-john', 'John Smith', 'john@bolao.test', CURRENT_TIMESTAMP, TRUE)
ON CONFLICT (id) DO NOTHING;


-- =====================================================
-- SECTION 3: Bets for existing mock user (matches 73-104)
-- User: Mock User (019d59db-4f87-7fe7-86bd-601c70867ea9)
-- Already has bets for matches 1-72 from V5 migration
-- =====================================================

INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 73),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 74),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 75),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 76),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 77),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 78),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 79),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 80),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 81),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 82),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 83),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 84),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 85),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 86),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 87),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 88),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 89),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 90),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 91),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 92),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 93),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 94),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 95),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 96),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 97),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 98),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 99),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 100),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 101),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 102),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 103),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 104),  1, 2);


-- =====================================================
-- SECTION 4: Bets for 3 new users (all 104 matches)
-- =====================================================

-- Ana Silva (019d59db-4f87-7fe8-0001-000000000001)
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   1),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   2),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   3),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   4),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   5),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   6),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   7),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   8),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =   9),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  10),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  11),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  12),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  13),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  14),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  15),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  16),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  17),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  18),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  19),  4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  20),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  21),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  22),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  23),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  24),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  25),  4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  26),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  27),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  28),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  29),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  30),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  31),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  32),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  33),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  34),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  35),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  36),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  37),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  38),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  39),  4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  40),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  41),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  42),  1, 5);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  43),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  44),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  45),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  46),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  47),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  48),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  49),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  50),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  51),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  52),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  53),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  54),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  55),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  56),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  57),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  58),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  59),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  60),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  61),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  62),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  63),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  64),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  65),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  66),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  67),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  68),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  69),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  70),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  71),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  72),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  73),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  74),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  75),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  76),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  77),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  78),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  79),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  80),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  81),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  82),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  83),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  84),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  85),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  86),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  87),  4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  88),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  89),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  90),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  91),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  92),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  93),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  94),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  95),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  96),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  97),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  98),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id =  99),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id = 100),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id = 101),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id = 102),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id = 103),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', (SELECT id FROM match WHERE match_id = 104),  1, 0);

-- Max Müller (019d59db-4f87-7fe8-0002-000000000002)
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   1),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   2),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   3),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   4),  4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   5),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   6),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   7),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   8),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =   9),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  10),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  11),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  12),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  13),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  14),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  15),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  16),  5, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  17),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  18),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  19),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  20),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  21),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  22),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  23),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  24),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  25),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  26),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  27),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  28),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  29),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  30),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  31),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  32),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  33),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  34),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  35),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  36),  0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  37),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  38),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  39),  4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  40),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  41),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  42),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  43),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  44),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  45),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  46),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  47),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  48),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  49),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  50),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  51),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  52),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  53),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  54),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  55),  4, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  56),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  57),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  58),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  59),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  60),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  61),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  62),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  63),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  64),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  65),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  66),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  67),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  68),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  69),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  70),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  71),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  72),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  73),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  74),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  75),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  76),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  77),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  78),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  79),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  80),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  81),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  82),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  83),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  84),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  85),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  86),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  87),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  88),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  89),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  90),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  91),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  92),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  93),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  94),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  95),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  96),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  97),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  98),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id =  99),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id = 100),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id = 101),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id = 102),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id = 103),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', (SELECT id FROM match WHERE match_id = 104),  0, 0);

-- John Smith (019d59db-4f87-7fe8-0003-000000000003)
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   1),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   2),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   3),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   4),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   5),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   6),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   7),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   8),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =   9),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  10),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  11),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  12),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  13),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  14),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  15),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  16),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  17),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  18),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  19),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  20),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  21),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  22),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  23),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  24),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  25),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  26),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  27),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  28),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  29),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  30),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  31),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  32),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  33),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  34),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  35),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  36),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  37),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  38),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  39),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  40),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  41),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  42),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  43),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  44),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  45),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  46),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  47),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  48),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  49),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  50),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  51),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  52),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  53),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  54),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  55),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  56),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  57),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  58),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  59),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  60),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  61),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  62),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  63),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  64),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  65),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  66),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  67),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  68),  0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  69),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  70),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  71),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  72),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  73),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  74),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  75),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  76),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  77),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  78),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  79),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  80),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  81),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  82),  2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  83),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  84),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  85),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  86),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  87),  3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  88),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  89),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  90),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  91),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  92),  2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  93),  3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  94),  1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  95),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  96),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  97),  1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  98),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id =  99),  2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id = 100),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id = 101),  1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id = 102),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id = 103),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', (SELECT id FROM match WHERE match_id = 104),  2, 0);
