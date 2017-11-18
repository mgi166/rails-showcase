Redis.current = Redis::Namespace.new(
  [Rails.application.engine_name, Rails.env].join("."),
  redis: Redis.new(
    url: Settings.redis.url,
    driver: :hiredis,
  )
)
