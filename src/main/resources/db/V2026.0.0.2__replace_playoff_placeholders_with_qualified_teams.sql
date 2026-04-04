-- Flyway Migration: V2026.0.0.2__replace_playoff_placeholders_with_qualified_teams.sql
-- =====================================================
-- Purpose: Replace the 6 playoff placeholder teams with the actual
--          qualified nations following the UEFA and FIFA Inter-confederation
--          playoffs (completed March 2026).
--
-- Playoff results:
--   UEFA Path A : Bosnia and Herzegovina (BIH) → GROUP_B  (replaces UEA)
--   UEFA Path B : Sweden (SWE)                 → GROUP_F  (replaces UEB)
--   UEFA Path C : Türkiye (TUR)                → GROUP_D  (replaces UEC)
--   UEFA Path D : Czechia (CZE)                → GROUP_A  (replaces UED)
--   Inter-confed 1: DR Congo (COD)             → GROUP_K  (replaces IC1)
--   Inter-confed 2: Iraq (IRQ)                 → GROUP_I  (replaces IC2)
--
-- Engine : PostgreSQL
-- =====================================================

-- UEFA Play-off A → Bosnia and Herzegovina (GROUP_B)
UPDATE team
SET name_en  = 'Bosnia and Herzegovina',
    name_de  = 'Bosnien und Herzegowina',
    name_pt  = 'Bósnia e Herzegovina',
    fifa_code = 'BIH',
    flag_url = 'https://flagcdn.com/w320/ba.png'
WHERE fifa_code = 'UEA';

-- UEFA Play-off B → Sweden (GROUP_F)
UPDATE team
SET name_en  = 'Sweden',
    name_de  = 'Schweden',
    name_pt  = 'Suécia',
    fifa_code = 'SWE',
    flag_url = 'https://flagcdn.com/w320/se.png'
WHERE fifa_code = 'UEB';

-- UEFA Play-off C → Türkiye (GROUP_D)
UPDATE team
SET name_en  = 'Türkiye',
    name_de  = 'Türkei',
    name_pt  = 'Turquia',
    fifa_code = 'TUR',
    flag_url = 'https://flagcdn.com/w320/tr.png'
WHERE fifa_code = 'UEC';

-- UEFA Play-off D → Czechia (GROUP_A)
UPDATE team
SET name_en  = 'Czechia',
    name_de  = 'Tschechien',
    name_pt  = 'Tchéquia',
    fifa_code = 'CZE',
    flag_url = 'https://flagcdn.com/w320/cz.png'
WHERE fifa_code = 'UED';

-- Inter-confed Play-off 1 → DR Congo (GROUP_K)
UPDATE team
SET name_en  = 'DR Congo',
    name_de  = 'DR Kongo',
    name_pt  = 'RD Congo',
    fifa_code = 'COD',
    flag_url = 'https://flagcdn.com/w320/cd.png'
WHERE fifa_code = 'IC1';

-- Inter-confed Play-off 2 → Iraq (GROUP_I)
UPDATE team
SET name_en  = 'Iraq',
    name_de  = 'Irak',
    name_pt  = 'Iraque',
    fifa_code = 'IRQ',
    flag_url = 'https://flagcdn.com/w320/iq.png'
WHERE fifa_code = 'IC2';
