# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    User.create({ email: params[:email], name: params[:name], organization: params[:organization] })
  end

  def user_exists
    user = User.find_by_email(params[:email])
    render json: { user_exists: user ? true : false }
  end
end
