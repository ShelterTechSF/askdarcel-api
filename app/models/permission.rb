# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  action      :integer
#  resource_id :bigint
#  service_id  :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_permissions_on_resource_id             (resource_id)
#  index_permissions_on_resource_id_and_action  (resource_id,action) UNIQUE
#  index_permissions_on_service_id              (service_id)
#  index_permissions_on_service_id_and_action   (service_id,action) UNIQUE
#

# The permissions system provides a way to assign specific permissions
# to a group to view/alter specific objects.

class Permission < ApplicationRecord
  enum action: { add: 0, view: 1, edit: 2, remove: 3 }

  has_and_belongs_to_many(:groups, join_table: "group_permissions")
  belongs_to :resource, optional: true
  belongs_to :service, optional: true
end
