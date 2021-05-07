# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
class AddressesController < ApplicationController
  def update
    service = Service.find_by_id(params[:service_id])
    address = Address.find_by_id(params[:id])
    if service && address
      if service.addresses.include?(address)
        render status: :ok
      else
        service.addresses << address
        service.save!
        render status: :created
      end
    else
      render status: :bad_request
    end
  end

  def destroy
    service = Service.find_by_id(params[:service_id])
    address = Address.find_by_id(params[:id])
    if service && address
      if service.addresses.include?(address)
        service.addresses.delete(address)
        render status: :no_content
      else
        render status: :ok
      end
    else
      render status: :bad_request
    end
  end
end
# rubocop:enable Metrics/MethodLength
