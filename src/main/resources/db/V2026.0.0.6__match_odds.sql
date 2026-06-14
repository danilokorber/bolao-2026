-- Add nullable odds columns to match table

ALTER TABLE match
    ADD COLUMN home_odds DOUBLE PRECISION,
    ADD COLUMN away_odds DOUBLE PRECISION,
    ADD COLUMN draw_odds DOUBLE PRECISION;
