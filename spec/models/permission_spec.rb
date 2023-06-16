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
require 'rails_helper'

RSpec.describe Permission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
