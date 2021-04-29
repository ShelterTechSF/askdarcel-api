# frozen_string_literal: true

class AddressesController < ApplicationController
  def update
    service = Service.find_by_id(params[:service_id])
    address = Address.find_by_id(params[:id])

    if service && address
      if service.addresses.include?(address)
        render status: :ok
        return
      else
        service.addresses << address
        service.save!
        render status: :created
      end
    else
      render status: :bad_request
    end
  end
end
