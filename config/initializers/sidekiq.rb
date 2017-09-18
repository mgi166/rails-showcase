Sidekiq.configure_client do |config|
  config.redis = {
    url: Redis.current.redis.client.options[:url],
    namespace: Redis.current.namespace,
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: Redis.current.redis.client.options[:url],
    namespace: Redis.current.namespace,
  }
end
