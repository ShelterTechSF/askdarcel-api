# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  ## COMMENTED OUT
  # Do not eager load code on boot.
  # config.eager_load = false
  ## COMMENTED OUT

  # Actually do eager load code on boot to workaround a concurrency/deadlocking
  # issue in Puma.
  # https://github.com/puma/puma/issues/1184
  config.eager_load = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.debug_exception_response_format = :api

  config.lograge.enabled = true

  config.hosts << 'askdarcel.lvh.me'
end
