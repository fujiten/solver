# frozen_string_literal: true

if Rails.env.production?
  JWTSessions.encryption_key = ENV["JWT_SESSION_KEY"]
else
  JWTSessions.encryption_key = "secret"
end

if !Rails.env.production?
  JWTSessions.token_store = :redis, { redis_url: REDIS_URL || "redis://redis:6379" }
end
