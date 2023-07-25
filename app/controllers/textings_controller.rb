# frozen_string_literal: true

require 'net/http'
require 'uri'

class TextingsController < ApplicationController
  def create
    text_data = aggregate_text_data

    # Make a request to Textellent API. If the request is successful, we store a record in our DB
    response = JSON.parse(post_textellent(text_data).body)
    Rails.logger.info(response)

    if response['status'] != 'success'
      render status: :bad_request, json: { error: 'failure' }
      return
    end
    update_db(text_data)
  end

  private

  def update_db(text_data)
    phone_number = text_data[:mobilePhone]
    recipient_name = text_data[:firstName]
    recipient = TextingRecipient.find_by(phone_number: phone_number)

    if recipient
      update_recipient(recipient, recipient_name)
    else
      recipient = create_new_recipient(recipient_name, phone_number)
    end

    create_texting_record(recipient)
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

  def create_texting_record(recipient)
    Texting.create(
      texting_recipient_id: recipient.id,
      service_id: texting_params[:service_id],
      resource_id: texting_params[:resource_id]
    )
  end

  def parse_phone_number
    Phonelib.parse(texting_params[:phone_number], 'US').national(false)
  end

  def get_resource_phone(resource)
    return resource.phones[0].number if resource.phones.any?

    ''
  end

  # rubocop:disable Metrics/MethodLength
  def get_listing_address(address_array, phone)
    if address_array.any?
      return {
        address1: address_array[0].address_1,
        address2: address_array[0].address_2,
        city: address_array[0].city,
        state_province: address_array[0].state_province,
        postal_code: address_array[0].postal_code,
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

  def generate_data(recipient_name, phone_number, categories, listing_name, address)
    {
      "firstName" => recipient_name,
      "lastName" => "",
      "mobilePhone" => phone_number,
      "phoneAlternate": "",
      "phoneHome" => "",
      "phoneWork" => "",
      "tags" => categories,
      "engagementType" => "Resource Info",
      "engagementInfo" => {
        "Org_Name" => listing_name,
        "Org_Address1" => address[:address1],
        "Org_Address2" => address[:address2],
        "City" => address[:city],
        "State" => address[:state_province],
        "Zip" => address[:postal_code],
        "Org_Phone" => address[:phone]
      }
    }.with_indifferent_access
  end

  def aggregate_text_data
    recipient_name = texting_params[:recipient_name]
    phone_number = parse_phone_number

    if texting_params[:service_id]
      data = get_service_data(recipient_name, phone_number, texting_params[:service_id])
    elsif texting_params[:resource_id]
      data = get_resource_data(recipient_name, phone_number, texting_params[:resource_id])
    end

    data
  end

  def get_service_data(recipient_name, phone_number, service_id)
    service = Service.includes(:categories).find(service_id)
    categories = service.categories.map(&:name)
    resource = Resource.find(service.resource_id)
    phone = get_resource_phone(resource)
    address = get_listing_address(service.addresses.any? ? service.addresses : resource.addresses, phone)

    generate_data(recipient_name, phone_number, categories, service.name, address)
  end

  def get_resource_data(recipient_name, phone_number, resource_id)
    resource = Resource.find(resource_id)
    phone = get_resource_phone(resource)
    resource_addresses = resource.addresses
    address = get_listing_address(resource_addresses, phone)
    categories = resource.categories.map(&:name)

    generate_data(recipient_name, phone_number, categories, resource.name, address)
  end

  def texting_params
    params.require(:data).permit(:recipient_name, :phone_number, :resource_id, :service_id)
  end

  # handling the post request to Textellent API.
  def post_textellent(data)
    url = URI.parse(Rails.configuration.x.textellent.url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url.path, {
                                    'Content-Type' => 'application/json',
                                    'authCode' => Rails.configuration.x.textellent.api_key
                                  })
    request.body = data.to_json
    http.request(request)
  end
  # rubocop:enable Metrics/MethodLength
end
