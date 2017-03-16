class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  private

  def require_authorization!
    head :unauthorized unless current_user
  end

  def require_admin_signed_in!
    render status: :unauthorized unless admin_signed_in?
  end

  def current_user
    return @current_user if defined? @current_user
    user_id = request.headers['Authorization']
    @current_user = User.where(id: user_id).first
  end
end
