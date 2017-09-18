redis_connection = proc {
  Redis.current
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: Settings.sidekiq.client_size, &redis_connection)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: Settings.sidekiq.server_size, &redis_connection)
end
