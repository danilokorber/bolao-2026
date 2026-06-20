-- Persists the real team a knockout placeholder slot (e.g. WGA, RGA) resolves to.
-- The slot resolution re-points match FKs from the placeholder to the real team,
-- which is lossy; this column keeps the slot -> team mapping recoverable so that
-- group-winner bets can be scored from the admin's authoritative slot decisions.
ALTER TABLE team
    ADD COLUMN resolved_team_id UUID NULL REFERENCES team(id);

CREATE INDEX idx_team_resolved_team ON team(resolved_team_id);
