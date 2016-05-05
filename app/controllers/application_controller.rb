class ApplicationController < ActionController::API
  skip_before_filter :verify_authenticity_token
  before_filter :add_allow_credentials_headers

  include ActionController::Helpers
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  def add_allow_credentials_headers
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end
end
