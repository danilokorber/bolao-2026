-- Allow negative points_earned in bet table (wrong prediction = -3 points)
ALTER TABLE bet DROP CONSTRAINT chk_bet_points;
ALTER TABLE bet ADD CONSTRAINT chk_bet_points CHECK (points_earned >= -3);
