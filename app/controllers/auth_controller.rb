# frozen_string_literal: true

class AuthController < ApplicationController
  def authenticate
    hash = {
      client_id: Rails.configuration.x.auth0.client_id,
      response_type: 'code',
      redirect_uri: auth0_callback_auth_url
    }
    redirect_to(URI::HTTPS.build(host: auth0_domain, path: '/authorize', query: hash.to_query).to_s)
  end

  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the session.
    # Refer to
    # https://github.com/auth0/omniauth-auth0/blob/master/EXAMPLES.md#example-of-the-resulting-authentication-hash
    # for complete information on 'omniauth.auth' contents.
    auth_info = request.env['omniauth.auth']
    session[:userinfo] = auth_info['extra']['raw_info']

    # Redirect to the URL you want after successful auth
    redirect_to '/api-docs'
  end

  def failure
    # Handles failed authentication -- Show a failure page (you can also handle with a redirect)
    @error_msg = request.params['message']
  end

  def logout
    # you will finish this in a later step
  end
end
