-- Separate the penalty shootout score from the after-extra-time score for
-- knockout matches. football-data.org folds the shootout into score.fullTime
-- (e.g. a 0-0 draw won 3-0 on penalties is reported as fullTime 3-0). We now
-- store the shootout result in its own columns and keep home_goals/away_goals
-- as the score after extra time. Existing finished matches self-heal on the
-- next football-data.org sync, which re-reads and re-splits the score.
ALTER TABLE match ADD COLUMN home_penalties INTEGER;
ALTER TABLE match ADD COLUMN away_penalties INTEGER;
