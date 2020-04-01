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

    # Jobs break unless this happens. Zeigeist gets the wrong job path and errors haard.
    config.load_defaults "6.0"
    config.autoloader = :classic

    # Initialization for Sentry.io, if the environment variable SENTRY_DSN exists, otherwise it is ignored
    # If using Heroku make sure to run `heroku labs:enable runtime-dyno-metadata -a myapp` to enable release
    # notifications
    Raven.configure do |config|
      config.dsn = ENV["SENTRY_DSN"]
      config.async = lambda { |event| SentryJob.perform_later(event) }
    end if ENV.key?("SENTRY_DSN")
  end
end
