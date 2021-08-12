# frozen_string_literal: true

require "rails_helper"
require 'swagger_helper'

RSpec.describe 'Phones' do
  describe '#destroy' do
    let(:resource) { create(:resource, name: 'test resource') }
    let!(:phone) { create(:phone, number: '416233242', resource_id: resource.id) }

    it 'deletes the phone successfully' do
      expect { delete "/phones/#{phone.id}" }.to change { Phone.count }.by(-1)
    end
  end
end
