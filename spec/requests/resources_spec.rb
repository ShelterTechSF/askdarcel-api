require "rails_helper"

RSpec.describe 'Resources' do
  context 'index' do
    context 'without a category_id' do
      let!(:resources) { create_list :resource, 4 }

      it 'returns all resources' do
        get '/resources'
        returned_ids = response_json.map { |r| r['id'] }
        expect(returned_ids).to match(resources.map(&:id))
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
        returned_ids = response_json.map { |r| r['id'] }
        expect(returned_ids).to match(resources_a.map(&:id))
      end
    end
  end
  context 'show' do
    let!(:resources) { create_list :resource, 4 }
    let!(:resource_a) { create :resource, name: 'a' }

    it 'returns specific resource' do
      get "/resources/#{resource_a.id}"
      expect(response_json).to include(
        'id' => resource_a.id,
        'addresses' => Array,
        'schedule' => Hash,
        'phones' => Array
      )
    end
  end
end
