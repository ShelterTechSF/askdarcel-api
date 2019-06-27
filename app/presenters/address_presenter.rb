# frozen_string_literal: true

class AddressPresenter < Jsonite
  property :id
  property :attention
  property :name
  property :address_1
  property :address_2
  property :address_3
  property :address_4
  property :city
  property :state_province
  property :postal_code
  property :country
  property :latitude
  property :longitude
end
