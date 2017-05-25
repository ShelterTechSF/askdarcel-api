class Resource < ActiveRecord::Base
  include AlgoliaSearch

  delegate :latitude, :longitude, to: :address, prefix: true, allow_nil: true

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :keywords
  has_one :address
  has_many :phones
  has_one :schedule
  has_many :notes
  has_many :services
  has_many :ratings
  has_many :change_requests

  algoliasearch per_environment: true do
    geoloc :address_latitude, :address_longitude

    add_attribute :address do
      if address.present?
        {
          city: address.city,
          state_province: address.state_province,
          postal_code: address.postal_code,
          country: address.country,
        }
      else
        {}
      end
    end

    add_attribute :notes do
     notes.map {|n| n.note } 
    end

    add_attribute :categories do
      categories.map {|c| c.name }
    end

    add_attribute :keywords do
     keywords.map {|k| k.name }
    end

    add_attribute :services do
      services.map {|s| {
        name: s.name,
      }}
    end
  end
end
