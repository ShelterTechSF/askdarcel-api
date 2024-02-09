# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.create({ email: params[:email], name: params[:name], organization: params[:organization] })
    render status: :created, json: UserPresenter.present(user)
  end

  def user_exists
    user = User.find_by_email(params[:email])
    render json: { user_exists: user ? true : false }
  end
end
