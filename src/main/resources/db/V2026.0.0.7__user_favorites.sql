CREATE TABLE user_favorite (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    favorite_user_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_favorite_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_favorite_target FOREIGN KEY (favorite_user_id) REFERENCES app_user(id) ON DELETE CASCADE,
    CONSTRAINT chk_user_favorite_not_self CHECK (user_id <> favorite_user_id)
);

CREATE INDEX idx_user_favorite_user ON user_favorite(user_id);
CREATE INDEX idx_user_favorite_target ON user_favorite(favorite_user_id);
CREATE UNIQUE INDEX idx_user_favorite_unique ON user_favorite(user_id, favorite_user_id);
