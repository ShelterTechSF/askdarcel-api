# frozen_string_literal: true

class PhonesController < ApplicationController
  def create
    phone_json = params[:phone]

    phone = Phone.create(resource_id: phone_json[:resource_id], number: phone_json[:number],
                         service_type: phone_json[:service_type], description: phone_json[:description])

    render status: :created, json: phone
  end

  def destroy
    phone = Phone.find params[:id]
    phone.delete
  end
end
