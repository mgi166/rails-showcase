Raven.configure do |config|
  config.dsn = Settings.sentry.dsn
  config.async = lambda { |event|
    Thread.new { Raven.send_event(event) }
  }
end
