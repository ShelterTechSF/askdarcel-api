class TextingsController < ApplicationController

  def create

    recipient_name = texting_params[:recipient_name]
    phone_number = parse_phone_number()
    service_id = texting_params[:service_id]

    # Make a request to Textellent API. If request successful we update our DB
    data = get_db_data(recipient_name, phone_number, service_id)
    response = post_textellent(data)

    if response['status'] != 'success'
      puts response['message']
      render status: :bad_request, json: { error: 'Message not sent' }
      return
    end

    recipient = TextingRecipient.find_by(phone_number: phone_number)

    unless recipient
      recipient = create_new_recipient(recipient_name, phone_number)
    else
      update_recipient(recipient, recipient_name)
    end

    create_new_texting(recipient, service_id)
    render status: :ok, json: { message:'Message sent' }
  end

  private

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

  def texting_params
    params.require(:data).permit(:recipient_name, :phone_number, :service_id)
  end

  def parse_phone_number()
    Phonelib.parse(texting_params[:phone_number], 'US').national(false)
  end

  # Generate a data object to send to Textellent API
  def get_db_data(recipient_name, phone_number, service_id)

    service = Service.includes(:categories).find(service_id)
    categories = service.categories.map { |c| c.name }
    resource = Resource.find(service.resource_id)
    address = resource.addresses

    phone = ''
    if resource.phones.any?
      phone = resource.phones[0].number
    end

    address_1 = ''
    address_2 = ''
    city = ''
    state_province = ''
    postal_code = ''

    if address.any?
      address_1 = address[0].address_1
      address_2 = address[0].address_2 || ''
      city = address[0].city
      state_province =  address[0].state_province
      postal_code = address[0].postal_code
    end

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
          "Org_Name" => service.name,
          "Org_Address1" => address_1,
          "Org_Address2" => address_2,
          "City" => city,
          "State" => state_province,
          "Zip" => postal_code,
          "Org_Phone" => phone
        }
    }

    data
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
    res = client.post 'https://client.textellent.com/api/v1/engagement/create.json', query

    JSON.parse(res.body)
  end
end
