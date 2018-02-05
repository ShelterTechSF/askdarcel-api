# frozen_string_literal: true

class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable
  include DeviseTokenAuth::Concerns::User
end
