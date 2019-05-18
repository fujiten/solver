JWTSessions.encryption_key = 'secret'
JWTSessions.token_store = :redis, { redis_url: REDIS_URL || "redis://redis:6379" }
