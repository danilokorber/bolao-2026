-- Relax bet points constraint to accommodate stage multipliers.
-- Worst case: base -6 × 3 (Semi Finals/Third Place/Final) = -18.
ALTER TABLE bet DROP CONSTRAINT chk_bet_points;
ALTER TABLE bet ADD CONSTRAINT chk_bet_points CHECK (points_earned >= -18);
