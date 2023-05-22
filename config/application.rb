require_relative 'boot'

require 'rails/all'

require 'google/apis/webmasters_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'omniauth'
require 'omniauth/google_oauth2'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebmasterApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    Webmasters = Google::Apis::WebmastersV3

  end
end
