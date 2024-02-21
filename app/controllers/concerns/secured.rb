# frozen_string_literal: true

# This concern is included in our ApplicationController.
# It instantiates an Auth0Client, which calls the validate_token method
# to validate Auth tokens included in requests from the front-end.
module Secured
  extend ActiveSupport::Concern

  REQUIRES_AUTHENTICATION = { message: 'Requires authentication' }.freeze
  BAD_CREDENTIALS = { message: 'Bad credentials' }.freeze
  MALFORMED_AUTHORIZATION_HEADER = {
    error: 'invalid_request',
    error_description: 'Authorization header value must follow this format: Bearer access-token',
    message: 'Bad credentials'
  }.freeze

  # The authorize method can be run as a before_action within a controller to validate
  # a user's token prior to allowing access to an endpoint.
  def authorize
    token = token_from_request

    return if performed?

    validation_response = Auth0Client.validate_token(token)

    error = validation_response.error
    unless error
      # Create user_id instance variable so that it can be compared against userId recieved from client
      @user_id = validation_response.decoded_token[0]['sub']
      return
    end

    render json: { message: error.message }, status: error.status
  end

  private

  def token_from_request
    authorization_header_elements = request.headers['Authorization']&.split

    render json: REQUIRES_AUTHENTICATION, status: :unauthorized and return unless authorization_header_elements

    render json: MALFORMED_AUTHORIZATION_HEADER, status: :unauthorized and return unless authorization_header_elements.length == 2

    scheme, token = authorization_header_elements

    render json: BAD_CREDENTIALS, status: :unauthorized and return unless scheme.downcase == 'bearer'

    token
  end
end
