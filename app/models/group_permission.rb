# frozen_string_literal: true

# == Schema Information
#
# Table name: group_permissions
#
#  group_id      :bigint           not null
#  permission_id :bigint           not null
#
class GroupPermission < ApplicationRecord
  belongs_to :group
  belongs_to :permission
end
