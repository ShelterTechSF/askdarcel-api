# spec/integration/categories_spec.rb
require 'swagger_helper'

describe 'sheltertech API', type: :request, swagger_doc: 'v1/swagger.json' do

  path '/categories/{id}' do

    get 'Retrieves a category' do
      tags 'Categories'
      produces 'application/json', 'application/xml'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'category found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            vocabulary: { type: :string }
          },
          required: [ 'id', 'name', 'vocabulary' ]

        let(:id) { Category.create(name: 'foo', vocabulary: 'bar').id }
        run_test!
      end

      response '404', 'category not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end


end


