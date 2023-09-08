# frozen_string_literal: true

# == Schema Information
#
# Table name: group_permissions
#
#  group_id      :bigint           not null
#  permission_id :bigint           not null
#
# Indexes
#
#  index_group_permissions_on_group_id_and_permission_id  (group_id,permission_id)
#  index_group_permissions_on_permission_id_and_group_id  (permission_id,group_id)
#
class GroupPermission < ApplicationRecord
  belongs_to :group
  belongs_to :permission
end
