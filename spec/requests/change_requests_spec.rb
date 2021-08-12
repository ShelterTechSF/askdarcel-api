require 'swagger_helper'

RSpec.describe 'change_requests', type: :request do

  path '/resources/{resource_id}/change_requests' do
    # You'll want to customize the parameter types...
    parameter 'resource_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:resource_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/services/{service_id}/change_requests' do
    # You'll want to customize the parameter types...
    parameter 'service_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:service_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/notes/{note_id}/change_requests' do
    # You'll want to customize the parameter types...
    parameter 'note_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:note_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/addresses/{address_id}/change_requests' do
    # You'll want to customize the parameter types...
    parameter 'address_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:address_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/schedule_days/{schedule_day_id}/change_requests' do
    # You'll want to customize the parameter types...
    parameter 'schedule_day_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:schedule_day_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/phones/{phone_id}/change_requests' do
    # You'll want to customize the parameter types...
    parameter 'phone_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:phone_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests/{change_request_id}/create' do
    # You'll want to customize the parameter types...
    parameter 'change_request_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:change_request_id) { '123' }

    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests/{change_request_id}/approve' do
    # You'll want to customize the parameter types...
    parameter 'change_request_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:change_request_id) { '123' }

    post(summary: 'approve change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests/{change_request_id}/reject' do
    # You'll want to customize the parameter types...
    parameter 'change_request_id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:change_request_id) { '123' }

    post(summary: 'reject change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests/pending_count' do
    get(summary: 'pending_count change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests/activity_by_timeframe' do
    get(summary: 'activity_by_timeframe change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests' do
    get(summary: 'list change_requests') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
    post(summary: 'create change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end

  path '/change_requests/{id}' do
    # You'll want to customize the parameter types...
    parameter 'id', in: :path, type: :string
    # ...and values used to make the requests.
    let(:id) { '123' }

    get(summary: 'show change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
    patch(summary: 'update change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
    put(summary: 'update change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
    delete(summary: 'delete change_request') do
      response(200, description: 'successful') do
        # You can add before/let blocks here to trigger the response code
      end
    end
  end
end
