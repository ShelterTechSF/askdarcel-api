# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
# Groups provide a way to categorize a given group of users and to assign
# specific permissions to said group

class Group < ApplicationRecord
  has_and_belongs_to_many(:users,
                          join_table: "user_groups")

  has_and_belongs_to_many(:permissions,
                          join_table: "group_permissions")
end
