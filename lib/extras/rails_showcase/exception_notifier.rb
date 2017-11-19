module RailsShowcase
  module ExceptionNotifier
    def self.notify(exception)
      Raven.capture_exception(exception)
      Rails.logger.error "[#{exception.class}] #{exception.message}"
      Rails.logger.error exception.backtrace.join("\n") if exception.backtrace
    end
  end
end
