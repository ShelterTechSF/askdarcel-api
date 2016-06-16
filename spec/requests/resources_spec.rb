require "rails_helper"

RSpec.describe 'Resources' do
  context 'index' do
    context 'without a category_id' do
      let!(:resources) { create_list :resource, 4 }

      it 'returns all resources' do
        get '/resources'
        expect(response_json).to match({})
        expect(response).to have_http_status(:bad_request)
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
  end
  context 'show' do
    let!(:resources) { create_list :resource, 4 }
    let!(:resource_a) do
      create :resource, name: 'a',
                        services: create_list(:service, 2)
    end

    it 'returns specific resource' do
      get "/resources/#{resource_a.id}"
      expect(response_json['resource']).to include(
        'id' => resource_a.id,
        'addresses' => Array,
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
  end
end
