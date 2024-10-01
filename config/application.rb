require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dizauto
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Moscow"
    config.active_record.default_timezone = :local
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_lib(ignore: %w[clouds])
    # config.autoload_lib(ignore: %w[tasks assets]) #if need ignore

    config.active_storage.variant_processor = :vips # :mini_magick
    I18n.available_locales = %i[en ru]
    config.i18n.default_locale = :ru

    config.to_prepare do
      Noticed::Event.include Noticed::EventExtensions
      Noticed::Notification.include Noticed::NotificationExtensions
    end
  end
end
