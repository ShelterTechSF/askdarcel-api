# frozen_string_literal: true

require 'jwt'
require 'net/http'

class Auth0Client
  AUTH_DOMAIN = URI::HTTPS.build(host: Rails.application.config.x.auth0.domain)
  Error = Struct.new(:message, :status)
  Response = Struct.new(:decoded_token, :error)

  def self.decode_token(token, jwks_hash)
    JWT.decode(token, nil, true, {
                 algorithm: 'RS256',
                 iss: URI.join(AUTH_DOMAIN, '/'), # Trailing slash is required to successfully validate token
                 verify_iss: true,
                 aud: Rails.application.config.x.auth0.audience,
                 verify_aud: true,
                 jwks: { keys: jwks_hash[:keys] }
               })
  end

  def self.fetch_jwks
    jwks_uri = URI.join(AUTH_DOMAIN, '.well-known/jwks.json')
    Net::HTTP.get_response jwks_uri
  end

  def self.validate_token(token)
    jwks_response = fetch_jwks

    unless jwks_response.is_a? Net::HTTPSuccess
      error = Error.new(message: 'Unable to verify credentials', status: :internal_server_error)
      Response.new(nil, error)
    end

    jwks_hash = JSON.parse(jwks_response.body).deep_symbolize_keys
    decoded_token = decode_token(token, jwks_hash)
    Response.new(decoded_token, nil)
  # rubocop:disable Lint/ShadowedException
  rescue JWT::DecodeError, JWT::VerificationError
    Response.new(nil, Error.new('Bad credentials', :unauthorized))
  end
  # rubocop:enable Lint/ShadowedException
end
