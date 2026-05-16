-- Flyway Migration: V2026.0.0.4__mock_data.sql
-- =============================================
-- Purpose: Mock data for development/testing.
--          Includes group stage results, knockout results,
--          and bets for test users.
-- =============================================

-- =============================================
-- PART 1: Mock group stage results
-- =============================================

UPDATE match SET home_goals = 2, away_goals = 0, status = 'FINISHED' WHERE match_id = 1;  -- MEX 2-0 RSA
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 2;  -- KOR 1-0 CZE
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 3;  -- CZE 2-2 RSA
UPDATE match SET home_goals = 3, away_goals = 0, status = 'FINISHED' WHERE match_id = 4;  -- MEX 3-0 KOR
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 5;  -- CZE 1-0 MEX
UPDATE match SET home_goals = 0, away_goals = 2, status = 'FINISHED' WHERE match_id = 6;  -- RSA 0-2 KOR

UPDATE match SET home_goals = 0, away_goals = 0, status = 'FINISHED' WHERE match_id = 7;  -- CAN 0-0 BIH
UPDATE match SET home_goals = 1, away_goals = 2, status = 'FINISHED' WHERE match_id = 8;  -- QAT 1-2 SUI
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 9;  -- SUI 1-1 BIH
UPDATE match SET home_goals = 3, away_goals = 0, status = 'FINISHED' WHERE match_id = 10; -- CAN 3-0 QAT
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 11; -- SUI 2-2 CAN
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 12; -- BIH 1-0 QAT

UPDATE match SET home_goals = 3, away_goals = 0, status = 'FINISHED' WHERE match_id = 13; -- BRA 3-0 MAR
UPDATE match SET home_goals = 0, away_goals = 0, status = 'FINISHED' WHERE match_id = 14; -- HAI 0-0 SCO
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 15; -- SCO 2-2 MAR
UPDATE match SET home_goals = 4, away_goals = 1, status = 'FINISHED' WHERE match_id = 16; -- BRA 4-1 HAI
UPDATE match SET home_goals = 1, away_goals = 4, status = 'FINISHED' WHERE match_id = 17; -- SCO 1-4 BRA
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 18; -- MAR 1-1 HAI

UPDATE match SET home_goals = 3, away_goals = 1, status = 'FINISHED' WHERE match_id = 19; -- USA 3-1 PAR
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 20; -- AUS 2-2 TUR
UPDATE match SET home_goals = 2, away_goals = 0, status = 'FINISHED' WHERE match_id = 21; -- USA 2-0 AUS
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 22; -- TUR 1-0 PAR
UPDATE match SET home_goals = 0, away_goals = 1, status = 'FINISHED' WHERE match_id = 23; -- TUR 0-1 USA
UPDATE match SET home_goals = 0, away_goals = 1, status = 'FINISHED' WHERE match_id = 24; -- PAR 0-1 AUS

UPDATE match SET home_goals = 3, away_goals = 0, status = 'FINISHED' WHERE match_id = 25; -- GER 3-0 CUW
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 26; -- CIV 1-1 ECU
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 27; -- GER 2-2 CIV
UPDATE match SET home_goals = 2, away_goals = 1, status = 'FINISHED' WHERE match_id = 28; -- ECU 2-1 CUW
UPDATE match SET home_goals = 0, away_goals = 3, status = 'FINISHED' WHERE match_id = 29; -- ECU 0-3 GER
UPDATE match SET home_goals = 0, away_goals = 1, status = 'FINISHED' WHERE match_id = 30; -- CUW 0-1 CIV

UPDATE match SET home_goals = 3, away_goals = 1, status = 'FINISHED' WHERE match_id = 31; -- NED 3-1 JPN
UPDATE match SET home_goals = 2, away_goals = 1, status = 'FINISHED' WHERE match_id = 32; -- SWE 2-1 TUN
UPDATE match SET home_goals = 3, away_goals = 1, status = 'FINISHED' WHERE match_id = 33; -- NED 3-1 SWE
UPDATE match SET home_goals = 0, away_goals = 0, status = 'FINISHED' WHERE match_id = 34; -- TUN 0-0 JPN
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 35; -- JPN 1-1 SWE
UPDATE match SET home_goals = 0, away_goals = 4, status = 'FINISHED' WHERE match_id = 36; -- TUN 0-4 NED

UPDATE match SET home_goals = 3, away_goals = 1, status = 'FINISHED' WHERE match_id = 37; -- IRN 3-1 NZL
UPDATE match SET home_goals = 2, away_goals = 1, status = 'FINISHED' WHERE match_id = 38; -- BEL 2-1 EGY
UPDATE match SET home_goals = 4, away_goals = 0, status = 'FINISHED' WHERE match_id = 39; -- BEL 4-0 IRN
UPDATE match SET home_goals = 0, away_goals = 1, status = 'FINISHED' WHERE match_id = 40; -- NZL 0-1 EGY
UPDATE match SET home_goals = 2, away_goals = 0, status = 'FINISHED' WHERE match_id = 41; -- EGY 2-0 IRN
UPDATE match SET home_goals = 1, away_goals = 4, status = 'FINISHED' WHERE match_id = 42; -- NZL 1-4 BEL

UPDATE match SET home_goals = 2, away_goals = 0, status = 'FINISHED' WHERE match_id = 43; -- ESP 2-0 CPV
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 44; -- KSA 2-2 URU
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 45; -- ESP 1-0 KSA
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 46; -- URU 1-1 CPV
UPDATE match SET home_goals = 2, away_goals = 1, status = 'FINISHED' WHERE match_id = 47; -- CPV 2-1 KSA
UPDATE match SET home_goals = 0, away_goals = 2, status = 'FINISHED' WHERE match_id = 48; -- URU 0-2 ESP

UPDATE match SET home_goals = 3, away_goals = 1, status = 'FINISHED' WHERE match_id = 49; -- FRA 3-1 SEN
UPDATE match SET home_goals = 3, away_goals = 3, status = 'FINISHED' WHERE match_id = 50; -- IRQ 3-3 NOR
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 51; -- FRA 1-1 IRQ
UPDATE match SET home_goals = 1, away_goals = 2, status = 'FINISHED' WHERE match_id = 52; -- NOR 1-2 SEN
UPDATE match SET home_goals = 0, away_goals = 3, status = 'FINISHED' WHERE match_id = 53; -- NOR 0-3 FRA
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 54; -- SEN 1-1 IRQ

UPDATE match SET home_goals = 3, away_goals = 2, status = 'FINISHED' WHERE match_id = 55; -- ARG 3-2 ALG
UPDATE match SET home_goals = 3, away_goals = 0, status = 'FINISHED' WHERE match_id = 56; -- AUT 3-0 JOR
UPDATE match SET home_goals = 2, away_goals = 0, status = 'FINISHED' WHERE match_id = 57; -- ARG 2-0 AUT
UPDATE match SET home_goals = 3, away_goals = 3, status = 'FINISHED' WHERE match_id = 58; -- JOR 3-3 ALG
UPDATE match SET home_goals = 0, away_goals = 2, status = 'FINISHED' WHERE match_id = 59; -- ALG 0-2 AUT
UPDATE match SET home_goals = 1, away_goals = 2, status = 'FINISHED' WHERE match_id = 60; -- JOR 1-2 ARG

UPDATE match SET home_goals = 3, away_goals = 1, status = 'FINISHED' WHERE match_id = 61; -- POR 3-1 COD
UPDATE match SET home_goals = 2, away_goals = 2, status = 'FINISHED' WHERE match_id = 62; -- UZB 2-2 COL
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 63; -- POR 1-0 UZB
UPDATE match SET home_goals = 0, away_goals = 2, status = 'FINISHED' WHERE match_id = 64; -- COL 0-2 COD
UPDATE match SET home_goals = 2, away_goals = 3, status = 'FINISHED' WHERE match_id = 65; -- COL 2-3 POR
UPDATE match SET home_goals = 1, away_goals = 0, status = 'FINISHED' WHERE match_id = 66; -- COD 1-0 UZB

UPDATE match SET home_goals = 3, away_goals = 2, status = 'FINISHED' WHERE match_id = 67; -- ENG 3-2 CRO
UPDATE match SET home_goals = 0, away_goals = 1, status = 'FINISHED' WHERE match_id = 68; -- GHA 0-1 PAN
UPDATE match SET home_goals = 1, away_goals = 1, status = 'FINISHED' WHERE match_id = 69; -- ENG 1-1 GHA
UPDATE match SET home_goals = 2, away_goals = 1, status = 'FINISHED' WHERE match_id = 70; -- PAN 2-1 CRO
UPDATE match SET home_goals = 0, away_goals = 3, status = 'FINISHED' WHERE match_id = 71; -- PAN 0-3 ENG
UPDATE match SET home_goals = 1, away_goals = 2, status = 'FINISHED' WHERE match_id = 72; -- CRO 1-2 GHA


-- =============================================
-- PART 2: Mock bets for user (019d4a2a)
-- =============================================

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


-- =============================================
-- PART 3: Mock knockout results and bets
-- =============================================

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


-- =============================================
-- PART 4: Bets for user (019d5e7f)
-- =============================================

INSERT INTO app_user (id, keycloak_id, name, email, created_at, active)
VALUES ('019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'mock-keycloak-carlos', 'Carlos Mendes', 'carlos@bolao.test', CURRENT_TIMESTAMP, TRUE)
ON CONFLICT (id) DO NOTHING;

DELETE FROM bet WHERE user_id = '019d5e7f-c13b-7a17-822d-7a1a57e614bf';

INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 1), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 2), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 3), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 4), 0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 5), 0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 6), 3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 7), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 8), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 9), 4, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 10), 0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 11), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 12), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 13), 3, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 14), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 15), 1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 16), 2, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 17), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 18), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 19), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 20), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 21), 2, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 22), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 23), 3, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 24), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 25), 0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 26), 2, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 27), 2, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 28), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 29), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 30), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 31), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 32), 3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 33), 3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 34), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 35), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 36), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 37), 4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 38), 4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 39), 1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 40), 3, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 41), 4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 42), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 43), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 44), 2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 45), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 46), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 47), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 48), 3, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 49), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 50), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 51), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 52), 4, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 53), 4, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 54), 4, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 55), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 56), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 57), 3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 58), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 59), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 60), 3, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 61), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 62), 3, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 63), 3, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 64), 2, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 65), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 66), 4, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 67), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 68), 2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 69), 1, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 70), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 71), 4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 72), 4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 73), 2, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 74), 4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 75), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 76), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 77), 4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 78), 4, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 79), 3, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 80), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 81), 2, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 82), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 83), 4, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 84), 0, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 85), 0, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 86), 1, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 87), 3, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 88), 1, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 89), 4, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 90), 3, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 91), 4, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 92), 2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 93), 2, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 94), 4, 3);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 95), 0, 1);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 96), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 97), 2, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 98), 4, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 99), 1, 4);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 100), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 101), 0, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 102), 1, 0);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 103), 0, 2);
INSERT INTO bet (id, user_id, match_id, home_goals_bet, away_goals_bet) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', (SELECT id FROM match WHERE match_id = 104), 0, 4);

-- ============================================================
-- GROUP WINNER BETS
-- Actual standings: A(MEX/KOR), B(CAN/SUI), C(BRA/MAR), D(USA/AUS),
--   E(GER/CIV), F(NED/SWE), G(BEL/EGY), H(ESP/CPV),
--   I(FRA/SEN), J(ARG/AUT), K(POR/COD), L(ENG/PAN)
-- ============================================================

-- Mock User (good predictions, misses some 2nd places)
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_A', (SELECT id FROM team WHERE fifa_code = 'MEX'), (SELECT id FROM team WHERE fifa_code = 'KOR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_B', (SELECT id FROM team WHERE fifa_code = 'CAN'), (SELECT id FROM team WHERE fifa_code = 'BIH'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_C', (SELECT id FROM team WHERE fifa_code = 'BRA'), (SELECT id FROM team WHERE fifa_code = 'MAR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_D', (SELECT id FROM team WHERE fifa_code = 'USA'), (SELECT id FROM team WHERE fifa_code = 'TUR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_E', (SELECT id FROM team WHERE fifa_code = 'GER'), (SELECT id FROM team WHERE fifa_code = 'ECU'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_F', (SELECT id FROM team WHERE fifa_code = 'NED'), (SELECT id FROM team WHERE fifa_code = 'JPN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_G', (SELECT id FROM team WHERE fifa_code = 'BEL'), (SELECT id FROM team WHERE fifa_code = 'IRN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_H', (SELECT id FROM team WHERE fifa_code = 'ESP'), (SELECT id FROM team WHERE fifa_code = 'URU'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_I', (SELECT id FROM team WHERE fifa_code = 'FRA'), (SELECT id FROM team WHERE fifa_code = 'SEN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_J', (SELECT id FROM team WHERE fifa_code = 'ARG'), (SELECT id FROM team WHERE fifa_code = 'AUT'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_K', (SELECT id FROM team WHERE fifa_code = 'POR'), (SELECT id FROM team WHERE fifa_code = 'COL'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9', 'GROUP_L', (SELECT id FROM team WHERE fifa_code = 'ENG'), (SELECT id FROM team WHERE fifa_code = 'GHA'));

-- Ana Silva (underdog lover, many wrong picks)
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_A', (SELECT id FROM team WHERE fifa_code = 'RSA'), (SELECT id FROM team WHERE fifa_code = 'CZE'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_B', (SELECT id FROM team WHERE fifa_code = 'BIH'), (SELECT id FROM team WHERE fifa_code = 'QAT'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_C', (SELECT id FROM team WHERE fifa_code = 'MAR'), (SELECT id FROM team WHERE fifa_code = 'BRA'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_D', (SELECT id FROM team WHERE fifa_code = 'AUS'), (SELECT id FROM team WHERE fifa_code = 'PAR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_E', (SELECT id FROM team WHERE fifa_code = 'CIV'), (SELECT id FROM team WHERE fifa_code = 'ECU'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_F', (SELECT id FROM team WHERE fifa_code = 'JPN'), (SELECT id FROM team WHERE fifa_code = 'TUN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_G', (SELECT id FROM team WHERE fifa_code = 'EGY'), (SELECT id FROM team WHERE fifa_code = 'NZL'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_H', (SELECT id FROM team WHERE fifa_code = 'KSA'), (SELECT id FROM team WHERE fifa_code = 'CPV'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_I', (SELECT id FROM team WHERE fifa_code = 'SEN'), (SELECT id FROM team WHERE fifa_code = 'IRQ'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_J', (SELECT id FROM team WHERE fifa_code = 'ALG'), (SELECT id FROM team WHERE fifa_code = 'JOR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_K', (SELECT id FROM team WHERE fifa_code = 'COL'), (SELECT id FROM team WHERE fifa_code = 'UZB'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001', 'GROUP_L', (SELECT id FROM team WHERE fifa_code = 'GHA'), (SELECT id FROM team WHERE fifa_code = 'CRO'));

-- Max Müller (European bias, decent picks)
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_A', (SELECT id FROM team WHERE fifa_code = 'MEX'), (SELECT id FROM team WHERE fifa_code = 'CZE'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_B', (SELECT id FROM team WHERE fifa_code = 'SUI'), (SELECT id FROM team WHERE fifa_code = 'CAN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_C', (SELECT id FROM team WHERE fifa_code = 'BRA'), (SELECT id FROM team WHERE fifa_code = 'SCO'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_D', (SELECT id FROM team WHERE fifa_code = 'USA'), (SELECT id FROM team WHERE fifa_code = 'TUR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_E', (SELECT id FROM team WHERE fifa_code = 'GER'), (SELECT id FROM team WHERE fifa_code = 'CIV'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_F', (SELECT id FROM team WHERE fifa_code = 'NED'), (SELECT id FROM team WHERE fifa_code = 'SWE'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_G', (SELECT id FROM team WHERE fifa_code = 'BEL'), (SELECT id FROM team WHERE fifa_code = 'EGY'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_H', (SELECT id FROM team WHERE fifa_code = 'ESP'), (SELECT id FROM team WHERE fifa_code = 'URU'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_I', (SELECT id FROM team WHERE fifa_code = 'FRA'), (SELECT id FROM team WHERE fifa_code = 'NOR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_J', (SELECT id FROM team WHERE fifa_code = 'AUT'), (SELECT id FROM team WHERE fifa_code = 'ARG'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_K', (SELECT id FROM team WHERE fifa_code = 'POR'), (SELECT id FROM team WHERE fifa_code = 'COD'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002', 'GROUP_L', (SELECT id FROM team WHERE fifa_code = 'ENG'), (SELECT id FROM team WHERE fifa_code = 'CRO'));

-- John Smith (English fan, casual picks)
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_A', (SELECT id FROM team WHERE fifa_code = 'KOR'), (SELECT id FROM team WHERE fifa_code = 'MEX'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_B', (SELECT id FROM team WHERE fifa_code = 'CAN'), (SELECT id FROM team WHERE fifa_code = 'SUI'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_C', (SELECT id FROM team WHERE fifa_code = 'BRA'), (SELECT id FROM team WHERE fifa_code = 'HAI'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_D', (SELECT id FROM team WHERE fifa_code = 'USA'), (SELECT id FROM team WHERE fifa_code = 'AUS'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_E', (SELECT id FROM team WHERE fifa_code = 'GER'), (SELECT id FROM team WHERE fifa_code = 'ECU'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_F', (SELECT id FROM team WHERE fifa_code = 'NED'), (SELECT id FROM team WHERE fifa_code = 'JPN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_G', (SELECT id FROM team WHERE fifa_code = 'BEL'), (SELECT id FROM team WHERE fifa_code = 'NZL'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_H', (SELECT id FROM team WHERE fifa_code = 'ESP'), (SELECT id FROM team WHERE fifa_code = 'KSA'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_I', (SELECT id FROM team WHERE fifa_code = 'FRA'), (SELECT id FROM team WHERE fifa_code = 'IRQ'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_J', (SELECT id FROM team WHERE fifa_code = 'ARG'), (SELECT id FROM team WHERE fifa_code = 'ALG'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_K', (SELECT id FROM team WHERE fifa_code = 'POR'), (SELECT id FROM team WHERE fifa_code = 'UZB'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003', 'GROUP_L', (SELECT id FROM team WHERE fifa_code = 'ENG'), (SELECT id FROM team WHERE fifa_code = 'PAN'));

-- Carlos Mendes (South American bias)
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_A', (SELECT id FROM team WHERE fifa_code = 'MEX'), (SELECT id FROM team WHERE fifa_code = 'RSA'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_B', (SELECT id FROM team WHERE fifa_code = 'CAN'), (SELECT id FROM team WHERE fifa_code = 'QAT'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_C', (SELECT id FROM team WHERE fifa_code = 'BRA'), (SELECT id FROM team WHERE fifa_code = 'MAR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_D', (SELECT id FROM team WHERE fifa_code = 'USA'), (SELECT id FROM team WHERE fifa_code = 'PAR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_E', (SELECT id FROM team WHERE fifa_code = 'GER'), (SELECT id FROM team WHERE fifa_code = 'CUW'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_F', (SELECT id FROM team WHERE fifa_code = 'NED'), (SELECT id FROM team WHERE fifa_code = 'TUN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_G', (SELECT id FROM team WHERE fifa_code = 'IRN'), (SELECT id FROM team WHERE fifa_code = 'BEL'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_H', (SELECT id FROM team WHERE fifa_code = 'ESP'), (SELECT id FROM team WHERE fifa_code = 'URU'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_I', (SELECT id FROM team WHERE fifa_code = 'FRA'), (SELECT id FROM team WHERE fifa_code = 'SEN'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_J', (SELECT id FROM team WHERE fifa_code = 'ARG'), (SELECT id FROM team WHERE fifa_code = 'JOR'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_K', (SELECT id FROM team WHERE fifa_code = 'POR'), (SELECT id FROM team WHERE fifa_code = 'COL'));
INSERT INTO group_winner_bet (id, user_id, group_name, first_place_team_id, second_place_team_id) VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf', 'GROUP_L', (SELECT id FROM team WHERE fifa_code = 'ENG'), (SELECT id FROM team WHERE fifa_code = 'CRO'));

-- ============================================================
-- CHAMPION BETS
-- Actual: Champion=ARG, Runner-up=ESP, Semifinalists=GER,FRA
-- ============================================================

-- Mock User: BRA champion, ARG runner-up, GER/FRA/ESP/NED semis
INSERT INTO champion_bet (id, user_id, champion_team_id, runner_up_team_id, semifinalist1_team_id, semifinalist2_team_id, semifinalist3_team_id, semifinalist4_team_id)
VALUES (uuid_generate_v4(), '019d59db-4f87-7fe7-86bd-601c70867ea9',
  (SELECT id FROM team WHERE fifa_code = 'BRA'), (SELECT id FROM team WHERE fifa_code = 'ARG'),
  (SELECT id FROM team WHERE fifa_code = 'GER'), (SELECT id FROM team WHERE fifa_code = 'FRA'),
  (SELECT id FROM team WHERE fifa_code = 'ESP'), (SELECT id FROM team WHERE fifa_code = 'NED'));

-- Ana Silva: NED champion, MAR runner-up, SEN/GHA/ALG/EGY semis (all underdogs)
INSERT INTO champion_bet (id, user_id, champion_team_id, runner_up_team_id, semifinalist1_team_id, semifinalist2_team_id, semifinalist3_team_id, semifinalist4_team_id)
VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0001-000000000001',
  (SELECT id FROM team WHERE fifa_code = 'NED'), (SELECT id FROM team WHERE fifa_code = 'MAR'),
  (SELECT id FROM team WHERE fifa_code = 'SEN'), (SELECT id FROM team WHERE fifa_code = 'GHA'),
  (SELECT id FROM team WHERE fifa_code = 'ALG'), (SELECT id FROM team WHERE fifa_code = 'EGY'));

-- Max Müller: GER champion, ESP runner-up, FRA/ARG/POR/BEL semis (nails most)
INSERT INTO champion_bet (id, user_id, champion_team_id, runner_up_team_id, semifinalist1_team_id, semifinalist2_team_id, semifinalist3_team_id, semifinalist4_team_id)
VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0002-000000000002',
  (SELECT id FROM team WHERE fifa_code = 'GER'), (SELECT id FROM team WHERE fifa_code = 'ESP'),
  (SELECT id FROM team WHERE fifa_code = 'FRA'), (SELECT id FROM team WHERE fifa_code = 'ARG'),
  (SELECT id FROM team WHERE fifa_code = 'POR'), (SELECT id FROM team WHERE fifa_code = 'BEL'));

-- John Smith: ENG champion, BRA runner-up, ARG/FRA/USA/ESP semis
INSERT INTO champion_bet (id, user_id, champion_team_id, runner_up_team_id, semifinalist1_team_id, semifinalist2_team_id, semifinalist3_team_id, semifinalist4_team_id)
VALUES (uuid_generate_v4(), '019d59db-4f87-7fe8-0003-000000000003',
  (SELECT id FROM team WHERE fifa_code = 'ENG'), (SELECT id FROM team WHERE fifa_code = 'BRA'),
  (SELECT id FROM team WHERE fifa_code = 'ARG'), (SELECT id FROM team WHERE fifa_code = 'FRA'),
  (SELECT id FROM team WHERE fifa_code = 'USA'), (SELECT id FROM team WHERE fifa_code = 'ESP'));

-- Carlos Mendes: ARG champion, BRA runner-up, FRA/ESP/POR/GER semis (best prediction!)
INSERT INTO champion_bet (id, user_id, champion_team_id, runner_up_team_id, semifinalist1_team_id, semifinalist2_team_id, semifinalist3_team_id, semifinalist4_team_id)
VALUES (uuid_generate_v4(), '019d5e7f-c13b-7a17-822d-7a1a57e614bf',
  (SELECT id FROM team WHERE fifa_code = 'ARG'), (SELECT id FROM team WHERE fifa_code = 'BRA'),
  (SELECT id FROM team WHERE fifa_code = 'FRA'), (SELECT id FROM team WHERE fifa_code = 'ESP'),
  (SELECT id FROM team WHERE fifa_code = 'POR'), (SELECT id FROM team WHERE fifa_code = 'GER'));


