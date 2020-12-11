class TextingsController < ApplicationController

  def create
    response = post_textellent(get_db_data)

    if response['status'] == 'success'
      recipient = TextingRecipient.find_by(phone_number: texting_params[:phone_number])

      if recipient
        texting = Texting.new(
          texting_recipient_id: recipient.id,
          service_id: texting_params[:service_id]
          )

        if texting.save
          render status: :ok, json: { message:'Message sent' }
        else
          render status: :bad_request
        end

      else
        recipient = TextingRecipient.new(
          recipient_name: texting_params[:recipient_name],
          phone_number: texting_params[:phone_number]
          )

        recipient.save

        texting = Texting.new(
          texting_recipient_id: recipient.id,
          service_id: texting_params[:service_id]
          )

        if texting.save
          render status: :ok, json: { message:'Message sent' }
        else
          render status: :bad_request
        end

      end

    else
      render status: :bad_request, json: { error: response['message'] }
    end
  end


  private

  def get_db_data
    recipient_name = texting_params[:recipient_name]
    phone_number = texting_params[:phone_number]
    service = Service.find(texting_params[:service_id])
    category_ids = service.category_ids
    resource = Resource.find(service.resource_id)
    address = resource.addresses
    phone = resource.phones[0].number

    categories = []
    category_ids.each do |category_id|
      categories << Category.find(category_id).name
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
        "Org_Address1" => address[0].address_1,
        "Org_Address2" => address[0].address_2,
        "City" => address[0].city,
        "State" => address[0].state_province,
        "Zip" => address[0].postal_code,
        "Org_Phone" => phone
      }
    }

    data
  end

  def texting_params
    params.require(:data).permit(:recipient_name, :phone_number, :service_id)
  end

  # handling the post request to Textellent API.
  def post_textellent(data)

    header = {
      'Content-Type' => 'application/json',
      'authCode' => ENV['TEXTELLENT_AUTH_CODE'],
    }

    query = {
      body: data.to_json
    }

    client = HTTPClient.new default_header: header
    res = client.post 'https://client.textellent.com/api/v1/engagement/create.json', query

    JSON.parse(res.body)

  end
end
