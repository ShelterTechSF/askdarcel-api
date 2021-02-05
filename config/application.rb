# frozen_string_literal: true

require File.expand_path('boot', __dir__)

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
    # Differentiate indexes for different AskDarcel instances.
    config.x.algolia.index_prefix = ENV['ALGOLIA_INDEX_PREFIX']

    config.x.algolia.enabled = [
      config.x.algolia.application_id.present?,
      config.x.algolia.api_key.present?,
      config.x.algolia.index_prefix.present?
    ].all?

    config.x.airtable.api_key = ENV['AIRTABLE_API_KEY']

    config.x.google.api_key = ENV['GOOGLE_API_KEY']

    config.x.textellent.api_key = ENV['TEXTELLENT_AUTH_CODE']

    config.x.textellent.url = 'https://client.textellent.com/api/v1/engagement/create.json'

    # rubocop:disable Metrics/LineLength
    # This is the public cert PEM for the JWT issuer
    # TODO this should be pulled dynamically once on startup
    pem = "-----BEGIN CERTIFICATE-----\nMIIDUTCCAjmgAwIBAgIRAJINhhzcHXz8TwNud9lVdOMwDQYJKoZIhvcNAQELBQAw\nYjELMAkGA1UEBhMCVVMxDjAMBgNVBAgTBVRleGFzMQ8wDQYDVQQHEwZBdXN0aW4x\nEzARBgNVBAoTCkNsb3VkZmxhcmUxHTAbBgNVBAMTFGNsb3VkZmxhcmVhY2Nlc3Mu\nY29tMB4XDTIwMDEyMzE4MjAzMFoXDTIwMDMyMzE4MjAzMFowYjELMAkGA1UEBhMC\nVVMxDjAMBgNVBAgTBVRleGFzMQ8wDQYDVQQHEwZBdXN0aW4xEzARBgNVBAoTCkNs\nb3VkZmxhcmUxHTAbBgNVBAMTFGNsb3VkZmxhcmVhY2Nlc3MuY29tMIIBIjANBgkq\nhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1bfNhQpbF5rC+9WeGJUXDAEwKS5BFaKB\nJI2RXqcabhTF5qErClzT147DOK5AXKarMV+zcLmOkK8qZklmxtJhcJ/MfH3c7rtG\nY6TqTvwU9SqBFq6YBDfZEVaxY+78xzWzYefilywE8cpzgYZXC56iRe0n+bCXu8HQ\nD/p3CXExjRqS++Pmr1+y27XxG8QH7WR7ETr9gnfTqAvMPw+B3C7FxVcNTqorycpi\now5Jiqr9SxyxZgZ79lwQ5WiQTeB0WLg7XfSK3kEqZ63NsAO03N6AQT+QQQprMYg8\noZ85aOlbEh8TahRZXeZiJ2jbEFDJoyuqCwroA1kgzaLKjSpjeOzXHwIDAQABowIw\nADANBgkqhkiG9w0BAQsFAAOCAQEApaUo2nAGYPCmAv3ZxfQXlC7kMSONdnluXf1S\n8ubmmwBYMNjaI22jc0Wr6d9q5DUvJK2GUmBpkVR7flbnv1NyCpciemFWhTv0csvP\n4xnc61xO8LA5Eu/JCh5j5WSTB5BRTnAIc7VHtQqHsZa6qF4v507PVbOVsMMqXphd\nMMK63u/pnzu49vaEYM5AFSNVNRPs/uLnwR6FY4vvBt+8sa7QGbmS2Xcmbg/BGVAV\nN2Acj+C9x58v9i7JwbhHUrOFuCG7HW06UX6g2j9zPl2Px88LWVUX2DNycD1VVpwi\nauDk2Cve8ImzQex/TsDpc3zy3g6kvsWAo5WGaS67yheQ+AAm/A==\n-----END CERTIFICATE-----\n"
    # rubocop:enable Metrics/LineLength
    config.x.authorization.cert = OpenSSL::X509::Certificate.new(pem)

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post options]
      end
    end
    config.after_initialize do
      Rails.env.production? do
        ActiveRecord::Migrator.migrate ::Rails.root.to_s + "/db/migrate"
      end
    end
  end
end
