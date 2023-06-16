# frozen_string_literal: true

# == Schema Information
#
# Table name: user_groups
#
#  user_id  :bigint           not null
#  group_id :bigint           not null
#
# Indexes
#
#  index_user_groups_on_group_id  (group_id)
#  index_user_groups_on_user_id   (user_id)
#
require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
