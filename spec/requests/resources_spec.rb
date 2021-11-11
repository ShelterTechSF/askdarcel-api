# frozen_string_literal: true

# spec/requests/resources_spec.rb

RSpec.describe 'Resources', type: :request do
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
      path '/resources' do
        get(summary: 'Retrieves resources by category_id and lat/long') do
          tags :resources
          produces 'application/json'
          parameter :category_id, in: :query, type: :integer, required: true
          parameter :lat, in: :query, type: :number, required: false
          parameter :long, in: :query, type: :number, required: false

          let(:close) { 10 }
          let(:far) { 50 }
          let(:further) { 100 }
          let!(:category) { create :category }
          let!(:resources) do
            [
              { latitude: close, longitude: 0 },
              { latitude: far, longitude: 0 },
              { latitude: further, longitude: 0 }
            ].map { |d| create(:resource, categories: [category], addresses: [create(:address, d)]) }
          end

          let(:category_id) { category.id }
          let(:lat) { close }
          let(:long) { close }

          response(200, description: 'resources found') do
            capture_example

            it 'returns the close resource before the far resource and before the further resource' do
              returned_address = response_json['resources'].map { |r| r['addresses'] }
              expect(returned_address[0][0]['latitude']).to eq(close.to_f.to_s)
              expect(returned_address[0][0]['longitude']).to eq(0.to_f.to_s)
              expect(returned_address[1][0]['latitude']).to eq(far.to_f.to_s)
              expect(returned_address[1][0]['longitude']).to eq(0.to_f.to_s)
              expect(returned_address[2][0]['latitude']).to eq(further.to_f.to_s)
              expect(returned_address[2][0]['longitude']).to eq(0.to_f.to_s)
            end
          end
        end
      end
    end
  end
  context 'show' do
    let!(:resources) { create_list :resource, 4 }
    let!(:resource_a) do
      resource = create :resource, name: 'a'
      services = create_list(:service, 1, resource: resource)
      resource.services = services
      resource
    end
    let!(:resource_b) do
      resource = create :resource, name: 'b'
      services = create_list(:service, 1, status: :pending, resource: resource)
      resource.services = services
      resource
    end
    path '/resources/{id}' do
      get(summary: 'Retrieves resources by id') do
        tags :resources
        produces 'application/json'
        parameter :id, in: :path, type: :integer, description: 'Resource ID'

        response(200, description: 'resource found') do
          let!(:id) { resource_a.id }
          capture_example

          it 'returns specific resource' do
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

        response(200, description: 'resource not found') do
          let(:id) { resource_b.id }
          capture_example

          it 'does not return unapproved services' do
            expect(response_json['resource']['services']).to have(0).items
          end
        end
      end
    end
  end
end
