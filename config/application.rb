require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AskdarcelApi
  class Application < Rails::Application
    config.api_only = true

    # Algolia
    config.x.algolia.application_id = ENV['ALGOLIA_APPLICATION_ID']
    config.x.algolia.api_key = ENV['ALGOLIA_API_KEY']
    config.x.algolia.enabled = config.x.algolia.application_id.present? && config.x.algolia.api_key.present?
    if Rails.env.production? && !config.x.algolia.enabled?
      raise 'ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY are required in production'
    end
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end
