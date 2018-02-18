# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating do
  describe '#valid?' do
    let(:user) { create :user }
    let(:resource) { create :resource }
    let(:rating_value) { 3 }
    let(:rating) do
      Rating.new user: user, resource: resource, rating: rating_value
    end

    subject { rating.valid? }

    it { is_expected.to be true }

    context 'with an invalid rating' do
      let(:rating_value) { 10 }

      it { is_expected.to be false }
    end
  end
end
