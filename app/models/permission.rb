# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  description :string
#  permission  :string           not null
#  object_type :string           not null
#  object_pk   :integer          not null
#  user_id     :bigint
#  group_id    :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# The permissions system provides a way to assign specific permissions
# to users and groups of users for specific objects. The object_type
# is intended to be either a "Resource" or "Service" and the object_pk
# is the private key for the selected object. The permission field
# can be a standard operation like "create", "read", "update", "destroy",
# or a custom field for more unique operations

class Permission < ApplicationRecord
  has_and_belongs_to_many(:users, join_table: "user_permissions")

  has_and_belongs_to_many(:groups, join_table: "group_permissions")
end
