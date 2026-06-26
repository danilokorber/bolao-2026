-- =====================================================
-- ROUTE VISITS (page-view telemetry, one row per route change)
-- =====================================================
CREATE TABLE route_visit (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    username VARCHAR(100) NOT NULL,
    session_id VARCHAR(64) NOT NULL,
    path VARCHAR(512) NOT NULL,
    screen_width INTEGER,
    screen_height INTEGER,
    viewport_width INTEGER,
    viewport_height INTEGER,
    device_pixel_ratio DOUBLE PRECISION,
    browser_name VARCHAR(64),
    browser_version VARCHAR(64),
    os_name VARCHAR(64),
    language VARCHAR(32),
    timezone VARCHAR(64),
    referrer TEXT,
    user_agent TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_route_visit_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

CREATE INDEX idx_route_visit_user ON route_visit(user_id);
CREATE INDEX idx_route_visit_session ON route_visit(session_id);
CREATE INDEX idx_route_visit_created ON route_visit(created_at);
