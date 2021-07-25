# frozen_string_literal: true

# spec/integration/categories_spec.rb
require 'swagger_helper'

RSpec.describe 'Categories API', type: :request, capture_examples: true do
  # GET all categories, same as the controller/index action
  path '/categories' do
    get(summary: 'Retrieves all categories') do
      tags :categories
      produces 'application/json'

      response(200, description: 'categories found') do
        it 'Returns the correct number of categories' do
          body = JSON.parse(response.body)
          expect(body['categories'].count).to eq Category.count
        end
      end
    end
  end
  # GET all featured categories = controller/featured
  path '/categories/featured' do
    get(summary: 'Gets featured categories') do
      tags :categories
      produces 'application/json'

      response(200, description: 'categories found') do
        it 'Returns the correct number of featured categories' do
          body = JSON.parse(response.body)
          expect(body['categories'].count).to eq Category.where(featured: true).count
        end
      end
    end
  end
  # Get Resources By Category (testing!)
  path '/resources?category_id' do
    get(summary: 'Retrieves resources by category_id') do
      tags :resources
      produces 'application/json'
      parameter :category_id, in: :query, type: :integer, required: true
      # should return all resources under the specific category
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

      response(200, description: 'resources found') do
        # capture_example
        it 'returns only resources with that category' do
          get "/resources?category_id=#{category_a.id}"
          returned_ids = response_json['resources'].map { |r| r['id'] }
          expect(returned_ids).to match_array(resources_a.map(&:id))
        end
        it 'Returns the correct number of resources' do
          body = JSON.parse(response.body)
          expect(body['resources'].count).to eq Resource.where(category_id: 1).count
        end
      end
    end
  end
  # Get Resources By Category and Sorted By Location
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
        # capture_example
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
  # Get Category By ID (testing!)
  path '/categories/{id}' do
    get(summary: 'Retrieves categories by id') do
      tags :categories
      produces 'application/json'
      parameter :id, in: :path, type: :integer, description: 'Category ID'

      response(200, description: 'category found') do
        let!(:id) { category_a.id }
        # capture_example
        it 'returns specific category' do
          expect(response_json['category']).to include(
            'name' => String,
            'id' => category_a.id,
            'top_level' => Array,
            'featured' => Boolean
          )
        end
      end

      response(200, description: 'category not found') do
        let(:id) { category_b.id }
        # capture_example
        it 'does not return unapproved services' do
          expect(response_json['category']['services']).to have(0).items
        end
      end
    end
  end
  # Get Resource By ID
  path '/resources/{id}' do
    get(summary: 'Retrieves resources by id') do
      tags :resources
      produces 'application/json'
      parameter :id, in: :path, type: :integer, description: 'Resource ID'

      response(200, description: 'resource found') do
        let!(:id) { resource_a.id }
        # capture_example
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
        # capture_example
        it 'does not return unapproved services' do
          expect(response_json['resource']['services']).to have(0).items
        end
      end
    end
  end
  # Get Service By ID
  path '/services/{id}' do
    let!(:service) do
      resource = create :resource, name: 'a'
      service = create :service, resource: resource
      service
    end
    get(summary: 'Retrieves a service by id') do
      tags :services
      produces 'application/json'
      parameter :id, in: :path, type: :integer, description: 'Service ID'

      response(200, description: 'service found') do
        let(:id) { service.id }

        it 'Has the correct response' do
          expect(response_json['service']).to include(
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
  end
  # Get Resource and Service Counts By Category (doing!)

  # Get All Eligibilities

  # Get Eligibilities By Category

  # Get Services By Categories (Doing! && testing!)
  path '/services?category_id' do
    let!(:category) { create :category }
    # create a resource, =>because service belongs to resource which belongs to category.
    let!(:service) do
      resource = create :resource, name: 'a', category_id: category.id
      service = create :service, resource: resource
      service
    end
    get(summary: 'Retrieves services by category_id') do
      tags :services
      produces 'application/json'
      parameter :category_id, in: :query, type: :integer, required: true
      parameter :id, in: :path, type: :integer, description: 'Service ID'

      response(200, description: 'service found') do
        let(:id) { service.id }
        it 'returns only services with that category' do
          get "/services?category_id=#{category.id}"
          returned_ids = response_json['services'].map { |s| s['id'] }
          expect(returned_ids).to match_array(services.map(&:id))
        end
        it 'Has the correct response' do
          expect(response_json['service']).to include(
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

    # service = category_a.services.first
    #
    # expect(response_json['category']['services'][0]).to include(
    #   'name' => service.name,
    #   'long_description' => service.long_description,
    #   'eligibility' => service.eligibility,
    #   'required_documents' => service.required_documents,
    #   'fee' => service.fee,
    #   'application_process' => service.application_process,
    #   'notes' => Array,
    #   'schedule' => Hash
    # )
  end
  # Get Services By Eligibilities
end
