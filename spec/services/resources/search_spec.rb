require 'spec_helper'

RSpec.describe Resources::Search do
  subject { described_class.perform query }

  let!(:resource) { create :resource }
  let!(:service) do
    create :service, resource: resource, long_description: service_desc
  end

  let(:query) { 'bed' }

  context 'with no matching associations' do
    let(:service_desc) { 'nothing of use' }

    it { is_expected.to be_empty }
  end

  context 'with a matching service' do
    let(:service_desc) { 'more beds than you can count' }

    it { is_expected.to eq([resource]) }

    context 'and a second matching service' do
      let!(:service2) { create :service, resource: resource, long_description: service_desc }

      it { is_expected.to eq([resource]) }
    end
  end
end
