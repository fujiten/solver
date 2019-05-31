JWTSessions.encryption_key = 'secret'
if Rails.env.development?
  JWTSessions.token_store = :redis, { redis_url: REDIS_URL || "redis://redis:6379" }
end
