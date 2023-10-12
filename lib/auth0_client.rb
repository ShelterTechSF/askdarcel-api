# frozen_string_literal: true

require 'jwt'
require 'net/http'

class Auth0Client
  Error = Struct.new(:message, :status)
  Response = Struct.new(:decoded_token, :error)

  def self.domain_url
    "https://#{Rails.application.config.x.auth0.domain}/"
  end

  def self.decode_token(token, jwks_hash)
    JWT.decode(token, nil, true, {
                 algorithm: 'RS256',
                 iss: domain_url,
                 verify_iss: true,
                 aud: Rails.application.config.x.auth0.audience,
                 verify_aud: true,
                 jwks: { keys: jwks_hash[:keys] }
               })
  end

  def self.jwks
    jwks_uri = URI("#{domain_url}.well-known/jwks.json")
    Net::HTTP.get_response jwks_uri
  end

  def self.jwks_hash(jwks_response_body)
    JSON.parse(jwks_response_body).deep_symbolize_keys
  end

  def self.validate_token(token)
    jwks_response = jwks

    unless jwks_response.is_a? Net::HTTPSuccess
      error = Error.new(message: 'Unable to verify credentials', status: :internal_server_error)
      Response.new(nil, error)
    end

    decoded_token = decode_token(token, jwks_hash(jwks_response.body))
    Response.new(decoded_token, nil)
  # rubocop:disable Lint/ShadowedException
  rescue JWT::DecodeError, JWT::VerificationError
    error = Error.new('Bad credentials', :unauthorized)
    Response.new(nil, error)
  end
  # rubocop:enable Lint/ShadowedException
end
