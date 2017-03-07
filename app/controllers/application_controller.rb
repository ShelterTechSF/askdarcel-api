class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  def cachable
    expires_in 20.minute, public: true, must_revalidate: true
  end
  before_action :cachable

  private

  def require_authorization!
    head :unauthorized unless current_user
  end

  def current_user
    return @current_user if defined? @current_user
    user_id = request.headers['Authorization']
    @current_user = User.where(id: user_id).first
  end
end
