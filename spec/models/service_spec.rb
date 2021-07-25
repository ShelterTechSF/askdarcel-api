# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  # show the updated_at time
  it 'after each update, touches the updated_at time of the associated resource' do
    # In other words, confirm that relationship between service and resource
    # has `touch: true` set. Thus, whenever a service is changed, the
    # `updated_at` of its associated resource will be touched, i.e. set to the
    # present.
    resource = create(:resource)
    service = create(:service, resource: resource)
    Resource.where(id: resource.id).update_all(updated_at: 1.hour.ago)
    expect(resource.reload.updated_at.to_i).to be_within(2).of(1.hour.ago.to_i)

    service.update(name: 'My Service Name')

    expect(resource.reload.updated_at.to_i).to be_within(2).of(Time.now.to_i)
  end
end
