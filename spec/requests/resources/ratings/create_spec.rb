# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resource Ratings' do
  let(:resource) { create :resource }
  let(:rating_body) do
    {
      rating: 3
    }
  end

  context 'when not authorized' do
    it 'returns not authorized' do
      post "/resources/#{resource.id}/ratings", params: { rating: rating_body }
      expect(resource.ratings).to be_empty
      expect(response).to be_unauthorized
    end
  end

  context 'when authorized' do
    let(:user) { create :user }

    it 'creates a rating' do
      post "/resources/#{resource.id}/ratings", params: { rating: rating_body }, headers: { 'Authorization' => user.id }
      expect(resource.ratings).to have(1).item
      expect(response_json).to match(
        'rating' => {
          'user' => {
            'id' => user.id,
            'name' => user.name
          },
          'rating' => 3.0,
          'review' => nil
        }
      )
    end

    context 'with a review' do
      let(:rating_body) do
        {
          rating: 3,
          review: 'Great staff.'
        }
      end

      it 'creates a rating and a review' do
        post "/resources/#{resource.id}/ratings", params: { rating: rating_body }, headers: { 'Authorization' => user.id }
        expect(resource.ratings).to have(1).item
        expect(resource.ratings.first.review).to be_present
        expect(response_json).to match(
          'rating' => {
            'user' => {
              'id' => user.id,
              'name' => user.name
            },
            'rating' => 3.0,
            'review' => rating_body[:review]
          }
        )
      end
    end
  end
end
