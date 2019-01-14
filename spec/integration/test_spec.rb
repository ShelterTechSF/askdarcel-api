# frozen_string_literal: true

# spec/integration/categories_spec.rb
require 'swagger_helper'

RSpec.describe 'Sheltertech API', type: :request, swagger_doc: 'v1/swagger.json' do
  path '/categories' do
    get 'Retrieves all categories' do
      tags 'Categories'
      produces 'application/json'

      response '200', 'categories found' do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     top_level: { type: :string },
                     featured: { type: :boolean }
                   },
                   required: %w[id name top_level featured]
                 }
               },
               required: %w[categories]
        let(:id) { Category.create(name: 'foo', vocabulary: 'bar').id }
        run_test!
      end
    end
  end
end
