# frozen_string_literal: true

# == Schema Information
#
# Table name: user_permissions
#
#  user_id       :bigint           not null
#  permission_id :bigint           not null
#
class UserPermission < ApplicationRecord
  belongs_to :user
  belongs_to :permission
end
