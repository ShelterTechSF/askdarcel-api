# frozen_string_literal: true

Raven.configure do |config|
  SENTRY_PUBLIC_KEY = 'd35c8b2336084e67b08f7c4b5eeb54b9'
  SENTRY_PROJECT_ID = '1291517'
  config.dsn = "https://#{SENTRY_PUBLIC_KEY}@sentry.io/#{SENTRY_PROJECT_ID}"

  # Filter out sensitive parameters such as passwords
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
