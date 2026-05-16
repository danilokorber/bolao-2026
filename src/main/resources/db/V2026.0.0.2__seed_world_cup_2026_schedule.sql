
-- Flyway Migration: V2026.0.0.2__seed_world_cup_2026_schedule.sql
-- =====================================================
-- Purpose: Seed the 2026 FIFA World Cup full schedule (all 104 matches)
--          with UTC/GMT kickoff times
--          and create all 48 participants,
--          plus knockout slot placeholders.
-- Engine : PostgreSQL (uuid-ossp required)
-- Author : M365 Copilot
-- Date   : 2026-01-15
-- Sources (accessed 2026-01-15):
--  - FIFA schedule overview & knockout bracket mapping:
--    https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026/articles/match-schedule-fixtures-results-teams-stadiums
--    https://www.fifa.com/en/tournaments/mens/worldcup/canadamexicousa2026/articles/knockout-stage-match-schedule-bracket
--  - NBC Sports full 104-match schedule with ET kickoff times:
--    https://www.nbcsports.com/soccer/news/2026-world-cup-schedule-confirmed-dates-times-stadiums-full-details
--  - Group allocations cross-check:
--    https://www.aljazeera.com/sports/2025/12/6/full-match-schedule-of-the-fifa-world-cup-2026-dates-start-times-stadiums
-- Notes:
--  * This migration stores UTC timestamps in match.match_datetime by converting from ET (EDT in Jun/Jul) using AT TIME ZONE.
--  * Team list includes 42 confirmed teams and 6 TBD playoff placeholders, totalling 48 participants.
--  * Additional placeholders (WG*/RG*, Wxx, Lxx, and Mxx) are added for knockout mapping and third-place opponents.
-- =====================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------
-- Participants (42 confirmed + 6 playoff placeholders = 48)
-- -----------------------------------------------------

INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Mexico', 'Mexiko', 'México', 'MEX', 'https://flagcdn.com/w320/mx.png', 'GROUP_A') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'South Africa', 'Südafrika', 'África do Sul', 'RSA', 'https://flagcdn.com/w320/za.png', 'GROUP_A') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Korea Republic', 'Südkorea', 'Coreia do Sul', 'KOR', 'https://flagcdn.com/w320/kr.png', 'GROUP_A') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Czechia', 'Tschechien', 'Tchéquia', 'CZE', 'https://flagcdn.com/w320/cz.png', 'GROUP_A') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Canada', 'Kanada', 'Canadá', 'CAN', 'https://flagcdn.com/w320/ca.png', 'GROUP_B') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Switzerland', 'Schweiz', 'Suíça', 'SUI', 'https://flagcdn.com/w320/ch.png', 'GROUP_B') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Qatar', 'Katar', 'Catar', 'QAT', 'https://flagcdn.com/w320/qa.png', 'GROUP_B') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Bosnia and Herzegovina', 'Bosnien und Herzegowina', 'Bósnia e Herzegovina', 'BIH', 'https://flagcdn.com/w320/ba.png', 'GROUP_B') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Brazil', 'Brasilien', 'Brasil', 'BRA', 'https://flagcdn.com/w320/br.png', 'GROUP_C') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Morocco', 'Marokko', 'Marrocos', 'MAR', 'https://flagcdn.com/w320/ma.png', 'GROUP_C') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Scotland', 'Schottland', 'Escócia', 'SCO', 'https://flagcdn.com/w320/gb-sct.png', 'GROUP_C') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Haiti', 'Haiti', 'Haiti', 'HAI', 'https://flagcdn.com/w320/ht.png', 'GROUP_C') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'USA', 'USA', 'EUA', 'USA', 'https://flagcdn.com/w320/us.png', 'GROUP_D') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Australia', 'Australien', 'Austrália', 'AUS', 'https://flagcdn.com/w320/au.png', 'GROUP_D') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Paraguay', 'Paraguay', 'Paraguai', 'PAR', 'https://flagcdn.com/w320/py.png', 'GROUP_D') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Türkiye', 'Türkei', 'Turquia', 'TUR', 'https://flagcdn.com/w320/tr.png', 'GROUP_D') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Germany', 'Deutschland', 'Alemanha', 'GER', 'https://flagcdn.com/w320/de.png', 'GROUP_E') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Ecuador', 'Ecuador', 'Equador', 'ECU', 'https://flagcdn.com/w320/ec.png', 'GROUP_E') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Cote d''Ivoire', 'Elfenbeinküste', 'Costa do Marfim', 'CIV', 'https://flagcdn.com/w320/ci.png', 'GROUP_E') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Curacao', 'Curaçao', 'Curaçao', 'CUW', 'https://flagcdn.com/w320/cw.png', 'GROUP_E') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Netherlands', 'Niederlande', 'Países Baixos', 'NED', 'https://flagcdn.com/w320/nl.png', 'GROUP_F') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Japan', 'Japan', 'Japão', 'JPN', 'https://flagcdn.com/w320/jp.png', 'GROUP_F') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Tunisia', 'Tunesien', 'Tunísia', 'TUN', 'https://flagcdn.com/w320/tn.png', 'GROUP_F') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Sweden', 'Schweden', 'Suécia', 'SWE', 'https://flagcdn.com/w320/se.png', 'GROUP_F') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Belgium', 'Belgien', 'Bélgica', 'BEL', 'https://flagcdn.com/w320/be.png', 'GROUP_G') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'IR Iran', 'Iran', 'Irã', 'IRN', 'https://flagcdn.com/w320/ir.png', 'GROUP_G') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Egypt', 'Ägypten', 'Egito', 'EGY', 'https://flagcdn.com/w320/eg.png', 'GROUP_G') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'New Zealand', 'Neuseeland', 'Nova Zelândia', 'NZL', 'https://flagcdn.com/w320/nz.png', 'GROUP_G') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Spain', 'Spanien', 'Espanha', 'ESP', 'https://flagcdn.com/w320/es.png', 'GROUP_H') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Uruguay', 'Uruguay', 'Uruguai', 'URU', 'https://flagcdn.com/w320/uy.png', 'GROUP_H') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Saudi Arabia', 'Saudi-Arabien', 'Arábia Saudita', 'KSA', 'https://flagcdn.com/w320/sa.png', 'GROUP_H') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Cape Verde', 'Kap Verde', 'Cabo Verde', 'CPV', 'https://flagcdn.com/w320/cv.png', 'GROUP_H') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'France', 'Frankreich', 'França', 'FRA', 'https://flagcdn.com/w320/fr.png', 'GROUP_I') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Senegal', 'Senegal', 'Senegal', 'SEN', 'https://flagcdn.com/w320/sn.png', 'GROUP_I') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Norway', 'Norwegen', 'Noruega', 'NOR', 'https://flagcdn.com/w320/no.png', 'GROUP_I') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Iraq', 'Irak', 'Iraque', 'IRQ', 'https://flagcdn.com/w320/iq.png', 'GROUP_I') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Argentina', 'Argentinien', 'Argentina', 'ARG', 'https://flagcdn.com/w320/ar.png', 'GROUP_J') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Austria', 'Österreich', 'Áustria', 'AUT', 'https://flagcdn.com/w320/at.png', 'GROUP_J') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Algeria', 'Algerien', 'Argélia', 'ALG', 'https://flagcdn.com/w320/dz.png', 'GROUP_J') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Jordan', 'Jordanien', 'Jordânia', 'JOR', 'https://flagcdn.com/w320/jo.png', 'GROUP_J') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Portugal', 'Portugal', 'Portugal', 'POR', 'https://flagcdn.com/w320/pt.png', 'GROUP_K') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Colombia', 'Kolumbien', 'Colômbia', 'COL', 'https://flagcdn.com/w320/co.png', 'GROUP_K') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Uzbekistan', 'Usbekistan', 'Uzbequistão', 'UZB', 'https://flagcdn.com/w320/uz.png', 'GROUP_K') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'DR Congo', 'DR Kongo', 'RD Congo', 'COD', 'https://flagcdn.com/w320/cd.png', 'GROUP_K') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'England', 'England', 'Inglaterra', 'ENG', 'https://flagcdn.com/w320/gb-eng.png', 'GROUP_L') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Croatia', 'Kroatien', 'Croácia', 'CRO', 'https://flagcdn.com/w320/hr.png', 'GROUP_L') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Panama', 'Panama', 'Panamá', 'PAN', 'https://flagcdn.com/w320/pa.png', 'GROUP_L') ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team (id, name_en, name_de, name_pt, fifa_code, flag_url, group_name) VALUES (uuid_generate_v4(), 'Ghana', 'Ghana', 'Gana', 'GHA', 'https://flagcdn.com/w320/gh.png', 'GROUP_L') ON CONFLICT (fifa_code) DO NOTHING;
-- Winners/Runners placeholders
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group A', 'Gewinner Gruppe A', 'Vencedor Grupo A', 'WGA', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group A', 'Zweiter Gruppe A', 'Vice Grupo A', 'RGA', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group B', 'Gewinner Gruppe B', 'Vencedor Grupo B', 'WGB', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group B', 'Zweiter Gruppe B', 'Vice Grupo B', 'RGB', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group C', 'Gewinner Gruppe C', 'Vencedor Grupo C', 'WGC', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group C', 'Zweiter Gruppe C', 'Vice Grupo C', 'RGC', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group D', 'Gewinner Gruppe D', 'Vencedor Grupo D', 'WGD', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group D', 'Zweiter Gruppe D', 'Vice Grupo D', 'RGD', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group E', 'Gewinner Gruppe E', 'Vencedor Grupo E', 'WGE', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group E', 'Zweiter Gruppe E', 'Vice Grupo E', 'RGE', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group F', 'Gewinner Gruppe F', 'Vencedor Grupo F', 'WGF', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group F', 'Zweiter Gruppe F', 'Vice Grupo F', 'RGF', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group G', 'Gewinner Gruppe G', 'Vencedor Grupo G', 'WGG', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group G', 'Zweiter Gruppe G', 'Vice Grupo G', 'RGG', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group H', 'Gewinner Gruppe H', 'Vencedor Grupo H', 'WGH', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group H', 'Zweiter Gruppe H', 'Vice Grupo H', 'RGH', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group I', 'Gewinner Gruppe I', 'Vencedor Grupo I', 'WGI', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group I', 'Zweiter Gruppe I', 'Vice Grupo I', 'RGI', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group J', 'Gewinner Gruppe J', 'Vencedor Grupo J', 'WGJ', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group J', 'Zweiter Gruppe J', 'Vice Grupo J', 'RGJ', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group K', 'Gewinner Gruppe K', 'Vencedor Grupo K', 'WGK', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group K', 'Zweiter Gruppe K', 'Vice Grupo K', 'RGK', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Group L', 'Gewinner Gruppe L', 'Vencedor Grupo L', 'WGL', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Runner-up Group L', 'Zweiter Gruppe L', 'Vice Grupo L', 'RGL', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
-- R32 third-place placeholders
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M74', '3. Platz Qualifikant für M74', '3º lugar classificado para M74', 'M74', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M77', '3. Platz Qualifikant für M77', '3º lugar classificado para M77', 'M77', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M79', '3. Platz Qualifikant für M79', '3º lugar classificado para M79', 'M79', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M80', '3. Platz Qualifikant für M80', '3º lugar classificado para M80', 'M80', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M81', '3. Platz Qualifikant für M81', '3º lugar classificado para M81', 'M81', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M82', '3. Platz Qualifikant für M82', '3º lugar classificado para M82', 'M82', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M85', '3. Platz Qualifikant für M85', '3º lugar classificado para M85', 'M85', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), '3rd-place qualifier for M87', '3. Platz Qualifikant für M87', '3º lugar classificado para M87', 'M87', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
-- Knockout winners & semi losers placeholders
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 73', 'Gewinner Spiel 73', 'Vencedor Jogo 73', 'W73', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 74', 'Gewinner Spiel 74', 'Vencedor Jogo 74', 'W74', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 75', 'Gewinner Spiel 75', 'Vencedor Jogo 75', 'W75', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 76', 'Gewinner Spiel 76', 'Vencedor Jogo 76', 'W76', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 77', 'Gewinner Spiel 77', 'Vencedor Jogo 77', 'W77', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 78', 'Gewinner Spiel 78', 'Vencedor Jogo 78', 'W78', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 79', 'Gewinner Spiel 79', 'Vencedor Jogo 79', 'W79', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 80', 'Gewinner Spiel 80', 'Vencedor Jogo 80', 'W80', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 81', 'Gewinner Spiel 81', 'Vencedor Jogo 81', 'W81', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 82', 'Gewinner Spiel 82', 'Vencedor Jogo 82', 'W82', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 83', 'Gewinner Spiel 83', 'Vencedor Jogo 83', 'W83', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 84', 'Gewinner Spiel 84', 'Vencedor Jogo 84', 'W84', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 85', 'Gewinner Spiel 85', 'Vencedor Jogo 85', 'W85', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 86', 'Gewinner Spiel 86', 'Vencedor Jogo 86', 'W86', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 87', 'Gewinner Spiel 87', 'Vencedor Jogo 87', 'W87', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 88', 'Gewinner Spiel 88', 'Vencedor Jogo 88', 'W88', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 89', 'Gewinner Spiel 89', 'Vencedor Jogo 89', 'W89', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 90', 'Gewinner Spiel 90', 'Vencedor Jogo 90', 'W90', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 91', 'Gewinner Spiel 91', 'Vencedor Jogo 91', 'W91', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 92', 'Gewinner Spiel 92', 'Vencedor Jogo 92', 'W92', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 93', 'Gewinner Spiel 93', 'Vencedor Jogo 93', 'W93', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 94', 'Gewinner Spiel 94', 'Vencedor Jogo 94', 'W94', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 95', 'Gewinner Spiel 95', 'Vencedor Jogo 95', 'W95', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 96', 'Gewinner Spiel 96', 'Vencedor Jogo 96', 'W96', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 97', 'Gewinner Spiel 97', 'Vencedor Jogo 97', 'W97', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 98', 'Gewinner Spiel 98', 'Vencedor Jogo 98', 'W98', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 99', 'Gewinner Spiel 99', 'Vencedor Jogo 99', 'W99', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 100', 'Gewinner Spiel 100', 'Vencedor Jogo 100', 'WA0', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 101', 'Gewinner Spiel 101', 'Vencedor Jogo 101', 'WA1', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 102', 'Gewinner Spiel 102', 'Vencedor Jogo 102', 'WA2', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 103', 'Gewinner Spiel 103', 'Vencedor Jogo 103', 'WA3', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Winner Match 104', 'Gewinner Spiel 104', 'Vencedor Jogo 104', 'WA4', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Loser Match 101', 'Verlierer Spiel 101', 'Perdedor Jogo 101', 'LA1', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;
INSERT INTO team(id,name_en,name_de,name_pt,fifa_code,flag_url,group_name) VALUES (uuid_generate_v4(), 'Loser Match 102', 'Verlierer Spiel 102', 'Perdedor Jogo 102', 'LA2', NULL, NULL) ON CONFLICT (fifa_code) DO NOTHING;

-- =====================
-- GROUP STAGE (A–L)
-- =====================
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  1, 537327,
       (SELECT id FROM team WHERE fifa_code='MEX'),
       (SELECT id FROM team WHERE fifa_code='RSA'),
       ((TIMESTAMP '2026-06-11 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_A','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  2, 537328,
       (SELECT id FROM team WHERE fifa_code='KOR'),
       (SELECT id FROM team WHERE fifa_code='CZE'),
       ((TIMESTAMP '2026-06-11 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_A','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  3, 537333,
       (SELECT id FROM team WHERE fifa_code='CZE'),
       (SELECT id FROM team WHERE fifa_code='RSA'),
       ((TIMESTAMP '2026-06-18 12:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_A','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  4, 537345,
       (SELECT id FROM team WHERE fifa_code='MEX'),
       (SELECT id FROM team WHERE fifa_code='KOR'),
       ((TIMESTAMP '2026-06-18 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_A','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  5, 537346,
       (SELECT id FROM team WHERE fifa_code='CZE'),
       (SELECT id FROM team WHERE fifa_code='MEX'),
       ((TIMESTAMP '2026-06-24 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_A','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  6, 537334,
       (SELECT id FROM team WHERE fifa_code='RSA'),
       (SELECT id FROM team WHERE fifa_code='KOR'),
       ((TIMESTAMP '2026-06-24 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_A','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  7, 537339,
       (SELECT id FROM team WHERE fifa_code='CAN'),
       (SELECT id FROM team WHERE fifa_code='BIH'),
       ((TIMESTAMP '2026-06-12 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_B','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  8, 537340,
       (SELECT id FROM team WHERE fifa_code='QAT'),
       (SELECT id FROM team WHERE fifa_code='SUI'),
       ((TIMESTAMP '2026-06-13 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_B','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  9, 537351,
       (SELECT id FROM team WHERE fifa_code='SUI'),
       (SELECT id FROM team WHERE fifa_code='BIH'),
       ((TIMESTAMP '2026-06-18 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_B','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  10, 537357,
       (SELECT id FROM team WHERE fifa_code='CAN'),
       (SELECT id FROM team WHERE fifa_code='QAT'),
       ((TIMESTAMP '2026-06-18 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_B','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  11, 537352,
       (SELECT id FROM team WHERE fifa_code='SUI'),
       (SELECT id FROM team WHERE fifa_code='CAN'),
       ((TIMESTAMP '2026-06-24 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_B','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  12, 537358,
       (SELECT id FROM team WHERE fifa_code='BIH'),
       (SELECT id FROM team WHERE fifa_code='QAT'),
       ((TIMESTAMP '2026-06-24 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_B','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  13, 537369,
       (SELECT id FROM team WHERE fifa_code='BRA'),
       (SELECT id FROM team WHERE fifa_code='MAR'),
       ((TIMESTAMP '2026-06-13 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_C','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  14, 537363,
       (SELECT id FROM team WHERE fifa_code='HAI'),
       (SELECT id FROM team WHERE fifa_code='SCO'),
       ((TIMESTAMP '2026-06-13 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_C','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  15, 537370,
       (SELECT id FROM team WHERE fifa_code='SCO'),
       (SELECT id FROM team WHERE fifa_code='MAR'),
       ((TIMESTAMP '2026-06-19 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_C','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  16, 537364,
       (SELECT id FROM team WHERE fifa_code='BRA'),
       (SELECT id FROM team WHERE fifa_code='HAI'),
       ((TIMESTAMP '2026-06-19 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_C','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  17, 537391,
       (SELECT id FROM team WHERE fifa_code='SCO'),
       (SELECT id FROM team WHERE fifa_code='BRA'),
       ((TIMESTAMP '2026-06-24 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_C','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  18, 537392,
       (SELECT id FROM team WHERE fifa_code='MAR'),
       (SELECT id FROM team WHERE fifa_code='HAI'),
       ((TIMESTAMP '2026-06-24 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_C','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  19, 537397,
       (SELECT id FROM team WHERE fifa_code='USA'),
       (SELECT id FROM team WHERE fifa_code='PAR'),
       ((TIMESTAMP '2026-06-12 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_D','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  20, 537398,
       (SELECT id FROM team WHERE fifa_code='AUS'),
       (SELECT id FROM team WHERE fifa_code='TUR'),
       ((TIMESTAMP '2026-06-13 00:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_D','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  21, 537403,
       (SELECT id FROM team WHERE fifa_code='USA'),
       (SELECT id FROM team WHERE fifa_code='AUS'),
       ((TIMESTAMP '2026-06-19 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_D','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  22, 537409,
       (SELECT id FROM team WHERE fifa_code='TUR'),
       (SELECT id FROM team WHERE fifa_code='PAR'),
       ((TIMESTAMP '2026-06-19 00:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_D','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  23, 537410,
       (SELECT id FROM team WHERE fifa_code='TUR'),
       (SELECT id FROM team WHERE fifa_code='USA'),
       ((TIMESTAMP '2026-06-25 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_D','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  24, 537404,
       (SELECT id FROM team WHERE fifa_code='PAR'),
       (SELECT id FROM team WHERE fifa_code='AUS'),
       ((TIMESTAMP '2026-06-25 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_D','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  25, 537329,
       (SELECT id FROM team WHERE fifa_code='GER'),
       (SELECT id FROM team WHERE fifa_code='CUW'),
       ((TIMESTAMP '2026-06-14 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_E','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  26, 537335,
       (SELECT id FROM team WHERE fifa_code='CIV'),
       (SELECT id FROM team WHERE fifa_code='ECU'),
       ((TIMESTAMP '2026-06-14 19:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_E','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  27, 537336,
       (SELECT id FROM team WHERE fifa_code='GER'),
       (SELECT id FROM team WHERE fifa_code='CIV'),
       ((TIMESTAMP '2026-06-20 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_E','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  28, 537330,
       (SELECT id FROM team WHERE fifa_code='ECU'),
       (SELECT id FROM team WHERE fifa_code='CUW'),
       ((TIMESTAMP '2026-06-20 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_E','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  29, 537347,
       (SELECT id FROM team WHERE fifa_code='ECU'),
       (SELECT id FROM team WHERE fifa_code='GER'),
       ((TIMESTAMP '2026-06-25 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_E','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  30, 537348,
       (SELECT id FROM team WHERE fifa_code='CUW'),
       (SELECT id FROM team WHERE fifa_code='CIV'),
       ((TIMESTAMP '2026-06-25 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_E','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  31, 537342,
       (SELECT id FROM team WHERE fifa_code='NED'),
       (SELECT id FROM team WHERE fifa_code='JPN'),
       ((TIMESTAMP '2026-06-14 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_F','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  32, 537341,
       (SELECT id FROM team WHERE fifa_code='SWE'),
       (SELECT id FROM team WHERE fifa_code='TUN'),
       ((TIMESTAMP '2026-06-14 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_F','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  33, 537360,
       (SELECT id FROM team WHERE fifa_code='NED'),
       (SELECT id FROM team WHERE fifa_code='SWE'),
       ((TIMESTAMP '2026-06-20 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_F','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  34, 537359,
       (SELECT id FROM team WHERE fifa_code='TUN'),
       (SELECT id FROM team WHERE fifa_code='JPN'),
       ((TIMESTAMP '2026-06-20 00:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_F','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  35, 537353,
       (SELECT id FROM team WHERE fifa_code='JPN'),
       (SELECT id FROM team WHERE fifa_code='SWE'),
       ((TIMESTAMP '2026-06-25 19:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_F','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  36, 537354,
       (SELECT id FROM team WHERE fifa_code='TUN'),
       (SELECT id FROM team WHERE fifa_code='NED'),
       ((TIMESTAMP '2026-06-25 19:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_F','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  37, 537371,
       (SELECT id FROM team WHERE fifa_code='IRN'),
       (SELECT id FROM team WHERE fifa_code='NZL'),
       ((TIMESTAMP '2026-06-15 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_G','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  38, 537365,
       (SELECT id FROM team WHERE fifa_code='BEL'),
       (SELECT id FROM team WHERE fifa_code='EGY'),
       ((TIMESTAMP '2026-06-15 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_G','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  39, 537372,
       (SELECT id FROM team WHERE fifa_code='BEL'),
       (SELECT id FROM team WHERE fifa_code='IRN'),
       ((TIMESTAMP '2026-06-21 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_G','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  40, 537366,
       (SELECT id FROM team WHERE fifa_code='NZL'),
       (SELECT id FROM team WHERE fifa_code='EGY'),
       ((TIMESTAMP '2026-06-21 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_G','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  41, 537399,
       (SELECT id FROM team WHERE fifa_code='EGY'),
       (SELECT id FROM team WHERE fifa_code='IRN'),
       ((TIMESTAMP '2026-06-26 23:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_G','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  42, 537393,
       (SELECT id FROM team WHERE fifa_code='NZL'),
       (SELECT id FROM team WHERE fifa_code='BEL'),
       ((TIMESTAMP '2026-06-26 23:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_G','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  43, 537394,
       (SELECT id FROM team WHERE fifa_code='ESP'),
       (SELECT id FROM team WHERE fifa_code='CPV'),
       ((TIMESTAMP '2026-06-15 12:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_H','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  44, 537400,
       (SELECT id FROM team WHERE fifa_code='KSA'),
       (SELECT id FROM team WHERE fifa_code='URU'),
       ((TIMESTAMP '2026-06-15 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_H','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  45, 537405,
       (SELECT id FROM team WHERE fifa_code='ESP'),
       (SELECT id FROM team WHERE fifa_code='KSA'),
       ((TIMESTAMP '2026-06-21 12:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_H','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  46, 537411,
       (SELECT id FROM team WHERE fifa_code='URU'),
       (SELECT id FROM team WHERE fifa_code='CPV'),
       ((TIMESTAMP '2026-06-21 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_H','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  47, 537412,
       (SELECT id FROM team WHERE fifa_code='CPV'),
       (SELECT id FROM team WHERE fifa_code='KSA'),
       ((TIMESTAMP '2026-06-26 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_H','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  48, 537406,
       (SELECT id FROM team WHERE fifa_code='URU'),
       (SELECT id FROM team WHERE fifa_code='ESP'),
       ((TIMESTAMP '2026-06-26 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_H','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  49, 537337,
       (SELECT id FROM team WHERE fifa_code='FRA'),
       (SELECT id FROM team WHERE fifa_code='SEN'),
       ((TIMESTAMP '2026-06-16 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_I','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  50, 537338,
       (SELECT id FROM team WHERE fifa_code='IRQ'),
       (SELECT id FROM team WHERE fifa_code='NOR'),
       ((TIMESTAMP '2026-06-16 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_I','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  51, 537344,
       (SELECT id FROM team WHERE fifa_code='FRA'),
       (SELECT id FROM team WHERE fifa_code='IRQ'),
       ((TIMESTAMP '2026-06-22 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_I','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  52, 537343,
       (SELECT id FROM team WHERE fifa_code='NOR'),
       (SELECT id FROM team WHERE fifa_code='SEN'),
       ((TIMESTAMP '2026-06-22 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_I','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  53, 537331,
       (SELECT id FROM team WHERE fifa_code='NOR'),
       (SELECT id FROM team WHERE fifa_code='FRA'),
       ((TIMESTAMP '2026-06-26 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_I','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  54, 537332,
       (SELECT id FROM team WHERE fifa_code='SEN'),
       (SELECT id FROM team WHERE fifa_code='IRQ'),
       ((TIMESTAMP '2026-06-26 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_I','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  55, 537355,
       (SELECT id FROM team WHERE fifa_code='ARG'),
       (SELECT id FROM team WHERE fifa_code='ALG'),
       ((TIMESTAMP '2026-06-16 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_J','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  56, 537356,
       (SELECT id FROM team WHERE fifa_code='AUT'),
       (SELECT id FROM team WHERE fifa_code='JOR'),
       ((TIMESTAMP '2026-06-17 00:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_J','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  57, 537361,
       (SELECT id FROM team WHERE fifa_code='ARG'),
       (SELECT id FROM team WHERE fifa_code='AUT'),
       ((TIMESTAMP '2026-06-22 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_J','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  58, 537362,
       (SELECT id FROM team WHERE fifa_code='JOR'),
       (SELECT id FROM team WHERE fifa_code='ALG'),
       ((TIMESTAMP '2026-06-22 23:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_J','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  59, 537349,
       (SELECT id FROM team WHERE fifa_code='ALG'),
       (SELECT id FROM team WHERE fifa_code='AUT'),
       ((TIMESTAMP '2026-06-27 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_J','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  60, 537350,
       (SELECT id FROM team WHERE fifa_code='JOR'),
       (SELECT id FROM team WHERE fifa_code='ARG'),
       ((TIMESTAMP '2026-06-27 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_J','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  61, 537395,
       (SELECT id FROM team WHERE fifa_code='POR'),
       (SELECT id FROM team WHERE fifa_code='COD'),
       ((TIMESTAMP '2026-06-17 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_K','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  62, 537396,
       (SELECT id FROM team WHERE fifa_code='UZB'),
       (SELECT id FROM team WHERE fifa_code='COL'),
       ((TIMESTAMP '2026-06-17 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_K','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  63, 537373,
       (SELECT id FROM team WHERE fifa_code='POR'),
       (SELECT id FROM team WHERE fifa_code='UZB'),
       ((TIMESTAMP '2026-06-23 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_K','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  64, 537374,
       (SELECT id FROM team WHERE fifa_code='COL'),
       (SELECT id FROM team WHERE fifa_code='COD'),
       ((TIMESTAMP '2026-06-23 22:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_K','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  65, 537367,
       (SELECT id FROM team WHERE fifa_code='COL'),
       (SELECT id FROM team WHERE fifa_code='POR'),
       ((TIMESTAMP '2026-06-27 19:30:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_K','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  66, 537368,
       (SELECT id FROM team WHERE fifa_code='COD'),
       (SELECT id FROM team WHERE fifa_code='UZB'),
       ((TIMESTAMP '2026-06-27 19:30:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_K','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  67, 537413,
       (SELECT id FROM team WHERE fifa_code='ENG'),
       (SELECT id FROM team WHERE fifa_code='CRO'),
       ((TIMESTAMP '2026-06-17 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_L','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  68, 537414,
       (SELECT id FROM team WHERE fifa_code='GHA'),
       (SELECT id FROM team WHERE fifa_code='PAN'),
       ((TIMESTAMP '2026-06-17 19:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_L','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  69, 537407,
       (SELECT id FROM team WHERE fifa_code='ENG'),
       (SELECT id FROM team WHERE fifa_code='GHA'),
       ((TIMESTAMP '2026-06-23 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_L','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  70, 537408,
       (SELECT id FROM team WHERE fifa_code='PAN'),
       (SELECT id FROM team WHERE fifa_code='CRO'),
       ((TIMESTAMP '2026-06-23 19:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_L','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  71, 537401,
       (SELECT id FROM team WHERE fifa_code='PAN'),
       (SELECT id FROM team WHERE fifa_code='ENG'),
       ((TIMESTAMP '2026-06-27 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_L','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  72, 537402,
       (SELECT id FROM team WHERE fifa_code='CRO'),
       (SELECT id FROM team WHERE fifa_code='GHA'),
       ((TIMESTAMP '2026-06-27 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'GROUP_L','SCHEDULED';

-- =====================
-- ROUND OF 32
-- =====================
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  73, 537417,
       (SELECT id FROM team WHERE fifa_code='RGA'),
       (SELECT id FROM team WHERE fifa_code='RGB'),
       ((TIMESTAMP '2026-06-28 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  74, 537423,
       (SELECT id FROM team WHERE fifa_code='WGC'),
       (SELECT id FROM team WHERE fifa_code='RGF'),
       ((TIMESTAMP '2026-06-29 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  75, 537415,
       (SELECT id FROM team WHERE fifa_code='WGE'),
       (SELECT id FROM team WHERE fifa_code='M74'),
       ((TIMESTAMP '2026-06-29 16:30:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  76, 537418,
       (SELECT id FROM team WHERE fifa_code='WGF'),
       (SELECT id FROM team WHERE fifa_code='RGC'),
       ((TIMESTAMP '2026-06-29 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  77, 537424,
       (SELECT id FROM team WHERE fifa_code='RGE'),
       (SELECT id FROM team WHERE fifa_code='RGI'),
       ((TIMESTAMP '2026-06-30 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  78, 537416,
       (SELECT id FROM team WHERE fifa_code='WGI'),
       (SELECT id FROM team WHERE fifa_code='M77'),
       ((TIMESTAMP '2026-06-30 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  79, 537425,
       (SELECT id FROM team WHERE fifa_code='WGA'),
       (SELECT id FROM team WHERE fifa_code='M79'),
       ((TIMESTAMP '2026-06-30 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  80, 537426,
       (SELECT id FROM team WHERE fifa_code='WGL'),
       (SELECT id FROM team WHERE fifa_code='M80'),
       ((TIMESTAMP '2026-07-01 12:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  81, 537422,
       (SELECT id FROM team WHERE fifa_code='WGG'),
       (SELECT id FROM team WHERE fifa_code='M82'),
       ((TIMESTAMP '2026-07-01 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  82, 537421,
       (SELECT id FROM team WHERE fifa_code='WGD'),
       (SELECT id FROM team WHERE fifa_code='M81'),
       ((TIMESTAMP '2026-07-01 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  83, 537420,
       (SELECT id FROM team WHERE fifa_code='WGH'),
       (SELECT id FROM team WHERE fifa_code='RGJ'),
       ((TIMESTAMP '2026-07-02 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  84, 537419,
       (SELECT id FROM team WHERE fifa_code='RGK'),
       (SELECT id FROM team WHERE fifa_code='RGL'),
       ((TIMESTAMP '2026-07-02 19:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  85, 537429,
       (SELECT id FROM team WHERE fifa_code='WGB'),
       (SELECT id FROM team WHERE fifa_code='M85'),
       ((TIMESTAMP '2026-07-02 23:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  86, 537428,
       (SELECT id FROM team WHERE fifa_code='RGD'),
       (SELECT id FROM team WHERE fifa_code='RGG'),
       ((TIMESTAMP '2026-07-03 14:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  87, 537427,
       (SELECT id FROM team WHERE fifa_code='WGJ'),
       (SELECT id FROM team WHERE fifa_code='RGH'),
       ((TIMESTAMP '2026-07-03 18:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  88, 537430,
       (SELECT id FROM team WHERE fifa_code='WGK'),
       (SELECT id FROM team WHERE fifa_code='M87'),
       ((TIMESTAMP '2026-07-03 21:30:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_32','SCHEDULED';

-- =====================
-- ROUND OF 16
-- =====================
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  89, 537376,
       (SELECT id FROM team WHERE fifa_code='W73'),
       (SELECT id FROM team WHERE fifa_code='W75'),
       ((TIMESTAMP '2026-07-04 13:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  90, 537375,
       (SELECT id FROM team WHERE fifa_code='W74'),
       (SELECT id FROM team WHERE fifa_code='W77'),
       ((TIMESTAMP '2026-07-04 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  91, 537377,
       (SELECT id FROM team WHERE fifa_code='W76'),
       (SELECT id FROM team WHERE fifa_code='W78'),
       ((TIMESTAMP '2026-07-05 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  92, 537378,
       (SELECT id FROM team WHERE fifa_code='W79'),
       (SELECT id FROM team WHERE fifa_code='W80'),
       ((TIMESTAMP '2026-07-05 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  93, 537379,
       (SELECT id FROM team WHERE fifa_code='W83'),
       (SELECT id FROM team WHERE fifa_code='W84'),
       ((TIMESTAMP '2026-07-06 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  94, 537380,
       (SELECT id FROM team WHERE fifa_code='W81'),
       (SELECT id FROM team WHERE fifa_code='W82'),
       ((TIMESTAMP '2026-07-06 20:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  95, 537381,
       (SELECT id FROM team WHERE fifa_code='W86'),
       (SELECT id FROM team WHERE fifa_code='W88'),
       ((TIMESTAMP '2026-07-07 12:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  96, 537382,
       (SELECT id FROM team WHERE fifa_code='W85'),
       (SELECT id FROM team WHERE fifa_code='W87'),
       ((TIMESTAMP '2026-07-07 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'ROUND_OF_16','SCHEDULED';

-- =====================
-- QUARTER-FINALS
-- =====================
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  97, 537383,
       (SELECT id FROM team WHERE fifa_code='W89'),
       (SELECT id FROM team WHERE fifa_code='W90'),
       ((TIMESTAMP '2026-07-09 16:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'QUARTER_FINALS','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  98, 537384,
       (SELECT id FROM team WHERE fifa_code='W93'),
       (SELECT id FROM team WHERE fifa_code='W94'),
       ((TIMESTAMP '2026-07-10 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'QUARTER_FINALS','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  99, 537385,
       (SELECT id FROM team WHERE fifa_code='W91'),
       (SELECT id FROM team WHERE fifa_code='W92'),
       ((TIMESTAMP '2026-07-11 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'QUARTER_FINALS','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  100, 537386,
       (SELECT id FROM team WHERE fifa_code='W95'),
       (SELECT id FROM team WHERE fifa_code='W96'),
       ((TIMESTAMP '2026-07-11 21:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'QUARTER_FINALS','SCHEDULED';

-- =====================
-- SEMI-FINALS
-- =====================
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  101, 537387,
       (SELECT id FROM team WHERE fifa_code='W97'),
       (SELECT id FROM team WHERE fifa_code='W98'),
       ((TIMESTAMP '2026-07-14 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'SEMI_FINALS','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  102, 537388,
       (SELECT id FROM team WHERE fifa_code='W99'),
       (SELECT id FROM team WHERE fifa_code='WA0'),
       ((TIMESTAMP '2026-07-15 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'SEMI_FINALS','SCHEDULED';

-- =====================
-- THIRD PLACE & FINAL
-- =====================
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  103, 537389,
       (SELECT id FROM team WHERE fifa_code='LA1'),
       (SELECT id FROM team WHERE fifa_code='LA2'),
       ((TIMESTAMP '2026-07-18 17:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'THIRD_PLACE','SCHEDULED';
INSERT INTO match (id, match_id, football_data_match_id, home_team_id, away_team_id, match_datetime, stage, status)
SELECT uuid_generate_v4(),  104, 537390,
       (SELECT id FROM team WHERE fifa_code='WA1'),
       (SELECT id FROM team WHERE fifa_code='WA2'),
       ((TIMESTAMP '2026-07-19 15:00:00' AT TIME ZONE 'America/New_York') AT TIME ZONE 'UTC'),
       'FINAL','SCHEDULED';
