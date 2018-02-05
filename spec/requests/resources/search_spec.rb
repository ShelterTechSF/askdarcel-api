# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  context 'search' do
    let!(:resources) do
      create_list :resource, 4
    end

    shared_examples 'a matching record' do |column_name|
      context "with #{column_name} match" do
        let(:query) { 'counsel' }

        let(:resource) do
          create(:resource, column_name =>
            'Counseling and support for those who need help')
        end

        let!(:resources) { create_list(:resource, 3) + [resource] }

        it 'returns the expected resource' do
          get "/resources/search?query=#{query}"
          expect(response).to be_ok
          returned_ids = response_json['resources'].map { |r| r['id'] }
          expect(returned_ids).to eq([resource.id])
        end
      end
    end

    Resources::Search::DatabaseStrategy::SEARCH_COLUMNS[:resources].each do |col|
      include_examples 'a matching record', col
    end
  end
end
