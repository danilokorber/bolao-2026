ALTER TABLE app_user_favorite
    DROP CONSTRAINT IF EXISTS chk_user_not_self_favorite;
