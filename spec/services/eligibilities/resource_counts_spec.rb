# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Eligibilities::ResourceCounts, type: :model do
  describe 'computing resource counts' do
    let!(:eligibilities) { create_list :eligibility, 4 }
    let!(:resources) { create_list(:resource, 3) }
    let!(:services) do
      services = []
      resources.each do |resource|
        services += Array.new(2) { create :service, resource: resource }
        resource.reload
      end
      services
    end

    before do
      # eligibility 1 associated with all 3 resources
      e1 = eligibilities[0]
      resources.each do |resource|
        resource.services.each { |s| e1.services << s }
      end

      # eligibility 2 associated with first 2 resources
      e2 = eligibilities[1]
      resources.take(2).each do |resource|
        resource.services.each { |s| e2.services << s }
      end

      # eligibility 3 and 4 associated with only first resource
      e3, e4 = eligibilities[2..-1]
      resources.take(1).each do |resource|
        resource.services.each { |s| e3.services << s }
        resource.services.each { |s| e4.services << s }
      end
    end

    it 'computes the map from eligibility id to resource count correctly' do
      eligibility_ids = eligibilities.map(&:id)

      result = described_class.compute(eligibility_ids)

      e1, e2, e3, e4 = eligibilities
      expect(result.is_a?(Hash)).to be true
      expect(result[e1.id]).to eq(3)
      expect(result[e2.id]).to eq(2)
      expect(result[e3.id]).to eq(1)
      expect(result[e4.id]).to eq(1)
    end
  end
end
