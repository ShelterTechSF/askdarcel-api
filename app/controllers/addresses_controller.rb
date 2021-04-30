# frozen_string_literal: true

class AddressesController < ApplicationController
  def update
    service = Service.find_by_id(params[:service_id])
    address = Address.find_by_id(params[:id])
    if service && address
      add_address_to_service(service, address)
      return
    else
      render status: :bad_request
    end
  end

  def destroy
    service = Service.find_by_id(params[:service_id])
    address = Address.find_by_id(params[:id])
    if service && address
      remove_address_from_service(service, address)
      return
    else
      render status: :bad_request
    end
  end

  private

  def add_address_to_service(service, address)
    if service.addresses.include?(address)
      render status: :ok
    else
      service.addresses << address
      service.save!
      render status: :created
    end
  end

  def remove_address_from_service(service, address)
    if service.addresses.include?(address)
      service.addresses.delete(address)
      service.save!
      render status: :no_content
    else
      render status: :ok
    end
  end
end
