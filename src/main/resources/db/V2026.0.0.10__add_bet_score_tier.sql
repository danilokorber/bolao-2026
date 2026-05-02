-- Add score tier column to track which scoring tier a bet achieved.
-- Allows ranking queries to count by tier regardless of stage-multiplied point values.
ALTER TABLE bet ADD COLUMN score_tier VARCHAR(10);
