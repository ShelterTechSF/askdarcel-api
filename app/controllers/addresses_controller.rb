# frozen_string_literal: true

class AddressesController < ApplicationController
  def update
    service = Service.find(params[:service_id])
    address = Address.find(params[:id])

    if !service.addresses.include?(address)
      service.addresses << address
      service.save!
      render status: :created
      return
    else
      render status: :precondition_failed
    end
  end
end
