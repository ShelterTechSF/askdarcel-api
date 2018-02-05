# frozen_string_literal: true

require "rails_helper"

RSpec.describe 'Resources' do
  context 'index' do
    context 'without a category_id' do
      let!(:resources) { create_list :resource, 4 }

      it 'returns all resources' do
        get '/resources'
        expect(response).to be_bad_request
        expect(response.body.strip).to be_empty
      end
    end

    context 'with a category_id' do
      let!(:category_a) { create :category, name: 'a' }
      let!(:category_b) { create :category, name: 'b' }
      let!(:resources) do
        create_list :resource, 2, categories: []
      end
      let!(:resources_a) do
        create_list :resource, 2, categories: [category_a]
      end
      let!(:resources_b) do
        create_list :resource, 2, categories: [category_b]
      end

      it 'returns only resources with that category' do
        get "/resources?category_id=#{category_a.id}"
        returned_ids = response_json['resources'].map { |r| r['id'] }
        expect(returned_ids).to match_array(resources_a.map(&:id))
      end
    end

    context 'with a category_id and latitude/longitude' do
      let(:close) { 10 }
      let(:far) { 50 }
      let(:further) { 100 }
      let!(:category) { create :category }
      let!(:resources) { create_list :resource, 3, categories: [category] }
      let!(:address_further) { create :address, latitude: further, longitude: 0, resource: resources[0] }
      let!(:address_close) { create :address, latitude: close, longitude: 0, resource: resources[1] }
      let!(:address_far) { create :address, latitude: far, longitude: 0, resource: resources[2] }
      it 'returns the close resource before the far resource and before the further resource' do
        get "/resources?category_id=#{category.id}&lat=#{close}&long=#{close}"
        returned_address = response_json['resources'].map { |r| r['address'] }
        expect(returned_address[0]['latitude']).to eq(address_close.latitude.to_s('F'))
        expect(returned_address[0]['longitude']).to eq(address_close.longitude.to_s('F'))
        expect(returned_address[1]['latitude']).to eq(address_far.latitude.to_s('F'))
        expect(returned_address[1]['longitude']).to eq(address_far.longitude.to_s('F'))
        expect(returned_address[2]['latitude']).to eq(address_further.latitude.to_s('F'))
        expect(returned_address[2]['longitude']).to eq(address_further.longitude.to_s('F'))
      end
    end
  end
  context 'show' do
    let!(:resources) { create_list :resource, 4 }
    let!(:resource_a) do
      resource = create :resource, name: 'a'
      create_list(:service, 1, resource: resource)
      resource
    end
    let!(:resource_b) do
      resource = create :resource, name: 'a'
      create_list(:service, 1, status: :pending, resource: resource)
      resource
    end

    it 'returns specific resource' do
      get "/resources/#{resource_a.id}"
      expect(response_json['resource']).to include(
        'id' => resource_a.id,
        'address' => Object,
        'categories' => Array,
        'schedule' => Hash,
        'phones' => Array,
        'services' => Array
      )
      service = resource_a.services.first
      expect(response_json['resource']['services'][0]).to include(
        'name' => service.name,
        'long_description' => service.long_description,
        'eligibility' => service.eligibility,
        'required_documents' => service.required_documents,
        'fee' => service.fee,
        'application_process' => service.application_process,
        'notes' => Array,
        'schedule' => Hash
      )
    end

    it 'does not return unapproved services' do
      get "/resources/#{resource_b.id}"
      expect(response_json['resource']['services']).to have(0).items
    end
  end
end
