module Utils
  module ExceptionNotifier
    def self.notify(exception)
      Rails.logger.error "[#{exception.class}] #{exception.message}"
      Rails.logger.error exception.backtrace.join("\n") if exception.backtrace
    end
  end
end
