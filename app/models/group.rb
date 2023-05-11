# frozen_string_literal: true

class Group < ApplicationRecord
  has_and_belongs_to_many(:users,
                          join_table: "user_groups",
                          foreign_key: "group_id")
  has_many :permissions, dependent: :destroy
end
