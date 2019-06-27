# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Eligibilities' do
  context 'index' do
    let!(:eligibilities) { create_list :eligibility, 3 }

    it 'returns all eligibilities ordered by name' do
      get '/eligibilities'

      expect(response).to be_ok
      items = response_json['eligibilities']
      expect(items.size).to eq(3)
      names = items.map { |item| item['name'] }
      expect(names).to eq(names.sort)
    end
  end

  context 'show' do
    let!(:eligibility) { create(:eligibility, name: 'Veterans') }

    context 'when record exists' do
      it 'returns eligibility successfully' do
        get "/eligibilities/#{eligibility.id}"

        expect(response).to be_ok
        item = response_json['eligibility']
        expect(item['id']).to eq(eligibility.id)
        expect(item['name']).to eq('Veterans')
      end
    end

    context 'when record does not exist' do
      let(:not_found_id) { Eligibility.maximum(:id) + 1 }

      it 'returns not found' do
        get "/eligibilities/#{not_found_id}"

        expect(response).to be_not_found
        expected_error_msg = "Couldn't find Eligibility with 'id'=#{not_found_id}"
        expect(response_json['error']).to include(expected_error_msg)
      end
    end
  end

  context 'update' do
    let!(:eligibility) { create(:eligibility, name: 'Senior') }

    context 'when update is valid' do
      it 'updates successfully' do
        put "/eligibilities/#{eligibility.id}", params: { name: 'Seniors', feature_rank: 3 }

        expect(response).to be_ok
        item = response_json['eligibility']
        expect(item['id']).to eq(eligibility.id)
        expect(item['name']).to eq('Seniors')
        expect(item['feature_rank']).to eq(3)
      end
    end

    context 'when name params is invalid' do
      it 'returns bad request response' do
        put "/eligibilities/#{eligibility.id}", params: { name: nil, feature_rank: 3 }

        expect(response).to be_bad_request
        expect(response_json['error']).to include('Validation errors: name')
        expect(response_json['error']).to include("can't be blank")
      end
    end

    context 'when updating feature_rank alone' do
      it 'updates successfully' do
        put "/eligibilities/#{eligibility.id}", params: { feature_rank: 1 }

        expect(response).to be_ok
        item = response_json['eligibility']
        expect(item['id']).to eq(eligibility.id)
        expect(item['name']).to eq(eligibility.name)
        expect(item['feature_rank']).to eq(1)
      end
    end

    context 'when updating a record that is not found' do
      let(:not_found_id) { Eligibility.maximum(:id) + 1 }

      it 'returns bad request response' do
        put "/eligibilities/#{not_found_id}", params: { feature_rank: 1 }

        expect(response).to be_not_found
        expected_error_msg = "Couldn't find Eligibility with 'id'=#{not_found_id}"
        expect(response_json['error']).to include(expected_error_msg)
      end
    end

    context 'when updating name to another value that already exists in table' do
      let!(:other_eligibility) { create(:eligibility, name: 'Veterans') }

      it 'returns bad request response' do
        put "/eligibilities/#{eligibility.id}", params: { name: other_eligibility.name }

        expect(response).to be_bad_request
        expect(response_json['error']).to include('Eligibility with name')
        expect(response_json['error']).to include('already exists')
      end
    end
  end

  context 'featured' do
    let!(:eligibilities) { create_list :eligibility, 3 }

    before do
      # e1 and e2 are featured, but not e3.
      # e2 has highest rank.
      e1, e2 = eligibilities[0..1]
      e1.update(feature_rank: 2)
      e2.update(feature_rank: 1)

      # e2 is associated with 2 resources
      2.times { e2.services << create(:service, resource: create(:resource)) }
      # e1 is associated with 1 resource
      e1.services << create(:service, resource: create(:resource))
    end

    it 'returns all featured eligibilities, ordered by feature_rank, along with resource counts' do
      get '/eligibilities/featured'

      expect(response).to be_ok
      items = response_json['eligibilities']
      expect(items.size).to eq(2)

      # TODO(cliff): deprecate resource_count field
      e1, e2 = eligibilities[0..1]
      expect(items[0]['id']).to eq(e2.id)
      expect(items[0]['service_count']).to eq(2)
      expect(items[0]['resource_count']).to eq(2)
      expect(items[1]['id']).to eq(e1.id)
      expect(items[1]['service_count']).to eq(1)
      expect(items[1]['resource_count']).to eq(1)
    end
  end
end
