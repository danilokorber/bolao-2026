-- Flyway Migration: V2026.0.0.5__mock_bets_for_user.sql
-- =====================================================
-- Purpose: Insert mock bets for all 72 group stage matches
--          for user 019d59db-4f87-7fe7-86bd-601c70867ea9.
-- Engine : PostgreSQL (uuid-ossp required)
-- =====================================================

-- Ensure the mock user exists
INSERT INTO app_user (id, keycloak_id, name, email, created_at, active)
VALUES ('019d59db-4f87-7fe7-86bd-601c70867ea9',
        'mock-keycloak-019d59db',
        'Mock User',
        'mock@bolao.test',
        CURRENT_TIMESTAMP,
        TRUE)
ON CONFLICT (id) DO NOTHING;

INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 1),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 2),  0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 3),  3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 4),  3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 5),  1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 6),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 7),  0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 8),  2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 9),  0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 10), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 11), 2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 12), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 13), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 14), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 15), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 16), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 17), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 18), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 19), 4, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 20), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 21), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 22), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 23), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 24), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 25), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 26), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 27), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 28), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 29), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 30), 1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 31), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 32), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 33), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 34), 2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 35), 3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 36), 0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 37), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 38), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 39), 4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 40), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 41), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 42), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 43), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 44), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 45), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 46), 3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 47), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 48), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 49), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 50), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 51), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 52), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 53), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 54), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 55), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 56), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 57), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 58), 2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 59), 3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 60), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 61), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 62), 3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 63), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 64), 1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 65), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 66), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 67), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 68), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 69), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 70), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 71), 2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', (SELECT id FROM match WHERE match_id = 72), 3, 1);
