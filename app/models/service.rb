# frozen_string_literal: true

class Service < ActiveRecord::Base
  include AlgoliaSearch

  enum status: { pending: 0, approved: 1, rejected: 2, inactive: 3 }

  belongs_to :resource, required: true, touch: true
  belongs_to :program
  has_many :notes, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_and_belongs_to_many :categories
  has_many :ratings, dependent: :destroy
  has_and_belongs_to_many :eligibilities, dependent: :destroy
  has_and_belongs_to_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :schedule
  accepts_nested_attributes_for :addresses

  before_create do
    self.status = :pending unless status
  end

  if Rails.configuration.x.algolia.enabled
    # Note: We can't use the per_environment option because both our production
    # and staging servers use the same RAILS_ENV.
    algoliasearch index_name: "#{Rails.configuration.x.algolia.index_prefix}_services_search", id: :algolia_id do # rubocop:disable Metrics/BlockLength
      add_attribute :_geoloc do
        if addresses.any?
          addresses.map do |a|
            { lat: a.address_latitude, lng: a.address_longitude }
          end
        else
          {lat: resource.address_latitude, lng: resource.address_longitude}
        end
      end

      add_attribute :addresses do
        if addresses.any?
          addresses.map do |a|
            {
              city: a.city,
              state_province: a.state_province,
              postal_code: a.postal_code,
              country: a.country,
              address_1: a.address_1
            }
          end
        else
          {
            city: resource.address.city,
            state_province: resource.address.state_province,
            postal_code: resource.address.postal_code,
            country: resource.address.country,
            address_1: resource.address.address_1
          }
        end
      end
      
      add_attribute :schedule do
        unless schedule.nil?
          schedule.schedule_days.map do |s|
            { opens_at: s.opens_at, closes_at: s.closes_at, day: s.day }
          end
        else resource.schedule.schedule_days.map do |s|
            { opens_at: s.opens_at, closes_at: s.closes_at, day: s.day }
          end
        end
      end

      add_attribute :service_of

      add_attribute :type

      add_attribute :service_id

      add_attribute :notes do
        notes.map(&:note)
      end

      add_attribute :categories do
        categories.map(&:name)
      end

      # add_attribute :keywords do
      #   keywords.map(&:name)
      # end
    end
  end

  def service_of
    resource.name
  end

  def service_id
    id
  end

  def type
    "service"
  end

  private
  def algolia_id
    "service_#{id}"
  end

end
