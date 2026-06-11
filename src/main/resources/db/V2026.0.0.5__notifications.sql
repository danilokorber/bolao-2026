-- =====================================================
-- NOTIFICATION PREFERENCES (per user)
-- =====================================================
CREATE TABLE notification_preference (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL UNIQUE,
    daily_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    event_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notification_preference_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

CREATE INDEX idx_notification_preference_user ON notification_preference(user_id);

-- =====================================================
-- PUSH SUBSCRIPTIONS (multi-device per user)
-- =====================================================
CREATE TABLE push_subscription (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    endpoint TEXT NOT NULL,
    p256dh_key VARCHAR(512) NOT NULL,
    auth_key VARCHAR(512) NOT NULL,
    user_agent VARCHAR(512),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_push_subscription_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_push_subscription_endpoint ON push_subscription(endpoint);
CREATE INDEX idx_push_subscription_user ON push_subscription(user_id);
CREATE INDEX idx_push_subscription_active ON push_subscription(active);

-- =====================================================
-- NOTIFICATION DELIVERY LOG (idempotency + audit)
-- =====================================================
CREATE TABLE notification_delivery_log (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    notification_type VARCHAR(32) NOT NULL,
    dedup_key VARCHAR(255) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    status VARCHAR(32) NOT NULL,
    error_message TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    CONSTRAINT fk_notification_delivery_log_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

CREATE INDEX idx_notification_delivery_user ON notification_delivery_log(user_id);
CREATE INDEX idx_notification_delivery_type ON notification_delivery_log(notification_type);
CREATE INDEX idx_notification_delivery_status ON notification_delivery_log(status);
