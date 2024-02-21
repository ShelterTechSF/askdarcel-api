# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize

  def create
    # If userId param received via frontend (from Auth0) doesn't match @user_id from auth0 token validation,
    # do not allow action
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless @user_id == params[:auth0_user_id]

    user_params = params.permit(:email, :name, :organization)
    user = User.new(user_params)

    if user.save
      render status: :created, json: UserPresenter.present(user)
    else
      render json: { error: 'Validation errors', messages: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    # User already exists. Don't do anything
  end
end
