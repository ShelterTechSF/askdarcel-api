class Resource < ActiveRecord::Base
  include AlgoliaSearch

  delegate :latitude, :longitude, to: :address, prefix: true, allow_nil: true

  enum status: { pending: 0, approved: 1, rejected: 2 }

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :keywords
  has_one :address, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :change_requests, dependent: :destroy

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :schedule

  before_create do
    self.status = :pending unless status
  end

  if Rails.configuration.x.algolia.enabled
    algoliasearch per_environment: true do
      geoloc :address_latitude, :address_longitude

      add_attribute :address do
        if address.present?
          {
            city: address.city,
            state_province: address.state_province,
            postal_code: address.postal_code,
            country: address.country
          }
        else
          {}
        end
      end

    add_attribute :notes do
     notes.map {|n| n.note }
    end

      add_attribute :categories do
        categories.map(&:name)
      end

      add_attribute :keywords do
        keywords.map(&:name)
      end

      add_attribute :services do
        services.map do |s|
          { name: s.name }
        end
      end
    end
  end
end
