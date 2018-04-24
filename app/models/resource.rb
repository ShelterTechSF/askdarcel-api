# frozen_string_literal: true

class Resource < ActiveRecord::Base
  include AlgoliaSearch

  delegate :latitude, :longitude, to: :address, prefix: true, allow_nil: true

  enum status: { pending: 0, approved: 1, rejected: 2, inactive: 3 }

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :keywords
  has_one :address, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :change_requests, dependent: :destroy
  has_many :programs, dependent: :destroy

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :schedule
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :phones

  before_create do
    self.status = :pending unless status
  end

  if Rails.configuration.x.algolia.enabled
    # Note: We can't use the per_environment option because both our production
    # and staging servers use the same RAILS_ENV.

    # Important: Use Resource.reindex! and Service.reindex! to reindex/create your index
    
    algoliasearch index_name: "#{Rails.configuration.x.algolia.index_prefix}_services_search", id: :algolia_id do # rubocop:disable Metrics/BlockLength
      geoloc :address_latitude, :address_longitude

      add_attribute :address do
        if address.present?
          {
            city: address.city,
            state_province: address.state_province,
            postal_code: address.postal_code,
            country: address.country,
            address_1: address.address_1
          }
        else
          {}
        end
      end 

      add_attribute :schedule do
        unless schedule.nil?
          schedule.schedule_days.map do |s|
            { opens_at: s.opens_at, closes_at: s.closes_at, day: s.day }
          end
        end
      end

      add_attribute :resource_id

      add_attribute :type

      add_attribute :notes do
        notes.map(&:note)
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

  def resource_id
    id
  end

  def type
    "resource"
  end
  
  private
  def algolia_id
    "resource_#{id}" # ensure the teacher & student IDs are not conflicting
  end

end
