# frozen_string_literal: true

require "rails_helper"
require 'swagger_helper'

RSpec.describe 'Notes' do
  describe '#destroy' do
    let(:resource) { create(:resource, name: 'test resource') }
    let(:service) { create(:service, name: 'test service', resource: resource) }
    let!(:note_with_resource) { create(:note, note: 'test note', resource: resource) }
    let!(:note_with_service) { create(:note, note: 'test note', service: service) }

    it 'deletes note_with_resource' do
      expect { delete "/notes/#{note_with_resource.id}" }.to change { Note.count }.by(-1)
    end

    it 'deletes note_with_service' do
      expect { delete "/notes/#{note_with_service.id}" }.to change { Note.count }.by(-1)
    end
  end
end
