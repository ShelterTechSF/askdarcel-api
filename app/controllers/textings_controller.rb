# frozen_string_literal: true

class TextingsController < ApplicationController
  def create
    recipient_name = texting_params[:recipient_name]
    phone_number = parse_phone_number
    service_id = texting_params[:service_id]
    data = get_db_data(recipient_name, phone_number, service_id)
    # Make a request to Textellent API. If request successful we update our DB

    response = JSON.parse(post_textellent(data).body)

    if response['status'] != 'success'
      render status: :bad_request, json: { error: 'failure' }
      return
    end
    update_db(recipient_name, phone_number, service_id)
  end

  private

  def update_db(recipient_name, phone_number, service_id)
    recipient = TextingRecipient.find_by(phone_number: phone_number)

    if recipient
      update_recipient(recipient, recipient_name)
    else
      recipient = create_new_recipient(recipient_name, phone_number)
    end

    create_new_texting(recipient, service_id)
    render status: :ok, json: { message: 'success' }
  end

  def create_new_recipient(recipient_name, phone_number)
    TextingRecipient.create(
      recipient_name: recipient_name,
      phone_number: phone_number
    )
  end

  def update_recipient(recipient, recipient_name)
    recipient.update(recipient_name: recipient_name)
  end

  def create_new_texting(recipient, service_id)
    Texting.create(
      texting_recipient_id: recipient.id,
      service_id: service_id
    )
  end

  def parse_phone_number
    Phonelib.parse(texting_params[:phone_number], 'US').national(false)
  end

  def get_ressource_phone(resource)
    return resource.phones[0].number if resource.phones.any?

    ''
  end

  # rubocop:disable Metrics/MethodLength
  def get_resource_address(resource_address, phone)
    if resource_address.any?
      return {
        address1: resource_address[0].address_1,
        address2: resource_address[0].address_2,
        city: resource_address[0].city,
        state_province: resource_address[0].state_province,
        postal_code: resource_address[0].postal_code,
        phone: phone
      }
    end
    {
      address1: '',
      address2: '',
      city: '',
      state_province: '',
      postal_code: '',
      phone: phone
    }
  end

  def generate_data(recipient_name, phone_number, categories, service_name, address)
    data = {
      "firstName" => recipient_name,
      "lastName" => "",
      "mobilePhone" => phone_number,
      "phoneAlternate": "",
      "phoneHome" => "",
      "phoneWork" => "",
      "tags" => categories,
      "engagementType" => "Resource Info",
      "engagementInfo" => {
        "Org_Name" => service_name,
        "Org_Address1" => address[:address1],
        "Org_Address2" => address[:address2],
        "City" => address[:city],
        "State" => address[:state_province],
        "Zip" => address[:postal_code],
        "Org_Phone" => address[:phone]
      }
    }
    data
  end

  def get_db_data(recipient_name, phone_number, service_id)
    service = Service.includes(:categories).find(service_id)
    categories = service.categories.map(&:name)
    resource = Resource.find(service.resource_id)
    phone = get_ressource_phone(resource)
    address = get_resource_address(resource.addresses, phone)

    generate_data(recipient_name, phone_number, categories, service.name, address)
  end

  def texting_params
    params.require(:data).permit(:recipient_name, :phone_number, :service_id)
  end

  # handling the post request to Textellent API.
  def post_textellent(data)
    header = {
      'Content-Type' => 'application/json',
      'authCode' => Rails.configuration.x.textellent.api_key
    }

    query = {
      body: data.to_json
    }

    client = HTTPClient.new default_header: header
    client.ssl_config.set_default_paths
    client.post Rails.configuration.x.textellent.url, query
  end
  # rubocop:enable Metrics/MethodLength
end
