# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.configuration.x.auth0.client_id,
    Rails.configuration.x.auth0.client_secret,
    Rails.configuration.x.auth0.domain,
    callback_path: '/auth/auth0/callback',
    authorize_params: {
      scope: 'openid profile'
    },
    provider_ignores_state: true
  )
end
