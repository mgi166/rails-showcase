require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsShowcase
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.helper false
      g.test_framework :rspec, view_specs: false, helper_specs: false, controller_specs: false
    end

    initializer :override_secrets do
      require 'yaml_vault/rails'
      YamlVault::Rails.override_secrets(
        Settings.yaml_vault.key,
        Settings.yaml_vault.cryptor,
      )
    end

    config.paths.add 'lib/extras', eager_load: true
    config.active_job.queue_adapter = :sidekiq
  end
end
