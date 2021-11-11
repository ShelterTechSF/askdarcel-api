# frozen_string_literal: true

# spec/requests/services_spec.rb

RSpec.describe 'Services API', type: :request, capture_examples: true do
  path '/services/{id}' do
    let!(:service) do
      resource = create :resource, name: 'a'
      service = create :service, resource: resource
      service
    end
    get(summary: 'Retrieves a service by id') do
      tags :services
      produces 'application/json'
      parameter :id, in: :path, type: :integer, description: 'Service ID'

      response(200, description: 'service found') do
        let(:id) { service.id }

        it 'Has the correct response' do
          expect(response_json['service']).to include(
            'name' => service.name,
            'long_description' => service.long_description,
            'eligibility' => service.eligibility,
            'required_documents' => service.required_documents,
            'fee' => service.fee,
            'application_process' => service.application_process,
            'notes' => Array,
            'schedule' => Hash
          )
        end
      end
    end
  end
end
