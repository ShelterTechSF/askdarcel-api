# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  description :string
#  permission  :string           not null
#  object_type :string           not null
#  object_pk   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# The permissions system provides a way to assign specific permissions
# to users and groups of users for specific objects. The object_type
# is intended to be either a "Resource" or "Service" and the object_pk
# is the private key for the selected object. The permission field
# can be a standard operation like "create", "read", "update", "destroy",
# or a custom field for more custom operations

class Permission < ApplicationRecord
  enum action: { add: 0, view: 1, edit: 2, remove: 3 }

  has_and_belongs_to_many(:groups, join_table: "group_permissions")
  belongs_to :resource, optional: true
  belongs_to :service, optional: true
end
