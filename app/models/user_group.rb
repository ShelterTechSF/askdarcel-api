# frozen_string_literal: true

# == Schema Information
#
# Table name: user_groups
#
#  user_id  :bigint           not null
#  group_id :bigint           not null
#
class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :groups
end
