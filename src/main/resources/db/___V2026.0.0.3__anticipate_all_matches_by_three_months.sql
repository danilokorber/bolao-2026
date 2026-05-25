-- Flyway Migration: V2026.0.0.3__anticipate_all_matches_by_three_months.sql
-- =====================================================
-- Purpose: Move all match schedules 3 months earlier for testing/demo
--          purposes (e.g. Jun 11 → Mar 11).
-- Engine : PostgreSQL
-- =====================================================

UPDATE match
SET match_datetime = match_datetime - INTERVAL '27 days';
