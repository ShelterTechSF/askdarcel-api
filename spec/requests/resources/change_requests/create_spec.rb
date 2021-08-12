# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Resource Change Requests' do
  let!(:resource) { create :resource }
  let(:params) do
    {
      name: 'New Name',
      long_description: 'New Long Description'
    }
  end

  it 'creates a change request and associated field changes' do
    resource.update(updated_at: 1.hour.ago)

    post "/resources/#{resource.id}/change_requests", params: { change_request: params }

    expect(resource.reload.name).to eq(params[:name])
    expect(resource.long_description).to eq(params[:long_description])

    expect(resource.change_requests).to have(1).item
    change_request = resource.change_requests.first

    expect(change_request.field_changes).to have(2).items
    field_changes = change_request.field_changes.to_a.sort_by(&:field_name)

    expect(field_changes.map(&:field_name)).to eq(%w[long_description name])
    expected_field_values = [
      params[:long_description],
      params[:name]
    ]
    expect(field_changes.map(&:field_value)).to eq(expected_field_values)

    # Verify that `updated_at` field have been set to the present.
    expect(resource.reload.updated_at.to_i).to be_within(5).of(Time.now.to_i)

    expect(response_json).to match(
      'resource_change_request' => {
        'id' => change_request.id,
        'status' => 'pending',
        'type' => 'ResourceChangeRequest',
        'object_id' => change_request.object_id,
        'field_changes' => [
          { 'field_name' => 'name', 'field_value' => params[:name] },
          { 'field_name' => 'long_description', 'field_value' => params[:long_description] }
        ]
      }
    )
  end

  context 'when an invalid change request is submitted' do
    let(:params) do
      { not_a_real_field_name: 'invalid field value' }
    end

    it 'rolls back changes and returns bad request status with error message' do
      post "/resources/#{resource.id}/change_requests", params: { change_request: params }

      expect(resource.change_requests).to be_empty
      expect(FieldChange.all).to be_empty

      expect(response).to be_bad_request
      expected_response = {
        'error' => 'Unknown attribute in request: "not_a_real_field_name"'
      }
      expect(response_json).to match(expected_response)
    end
  end
end
