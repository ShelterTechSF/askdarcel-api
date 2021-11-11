# frozen_string_literal: true

# spec/integration/categories_spec.rb

RSpec.describe 'Categories API', type: :request, capture_examples: true do
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
end
