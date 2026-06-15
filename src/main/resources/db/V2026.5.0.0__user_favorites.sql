-- Favorites relation between users (user favorites another user)
CREATE TABLE IF NOT EXISTS app_user_favorite (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    favorite_id UUID NOT NULL,
    CONSTRAINT fk_app_user_favorite_user
        FOREIGN KEY (user_id) REFERENCES app_user (id) ON DELETE CASCADE,
    CONSTRAINT fk_app_user_favorite_favorite
        FOREIGN KEY (favorite_id) REFERENCES app_user (id) ON DELETE CASCADE,
    CONSTRAINT uk_user_favorite UNIQUE (user_id, favorite_id),
    CONSTRAINT chk_user_not_self_favorite CHECK (user_id <> favorite_id)
);

CREATE INDEX IF NOT EXISTS idx_user_id ON app_user_favorite (user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_id ON app_user_favorite (favorite_id);