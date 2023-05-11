# frozen_string_literal: true

class User < ActiveRecord::Base
  has_and_belongs_to_many(:groups,
                          join_table: "user_groups")
  has_many :permissions, dependent: :destroy
end
