-- Flyway Migration: V2026.0.0.4__mock_group_stage_results.sql
-- =====================================================
-- Purpose: Populate mock results for all 72 group stage matches
--          for development and testing purposes.
-- Engine : PostgreSQL
-- =====================================================

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
