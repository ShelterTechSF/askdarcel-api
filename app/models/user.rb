# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
end
