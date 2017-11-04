require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AskdarcelApi
  class Application < Rails::Application
    config.api_only = true
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
    config.after_initialize do
      ActiveRecord::Migrator.migrate "db/migrate"
    end
  end
end
