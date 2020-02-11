require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Caucus
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Sidekiq as the default ActiveJob handler
    config.active_job.queue_adapter = :sidekiq

    # We add in the app/lib folder for some custom stuff
    config.autoload_paths << Rails.root.join("app/lib")
  end
end
