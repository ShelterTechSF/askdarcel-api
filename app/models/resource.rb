# frozen_string_literal: true
class Resource < ActiveRecord::Base
  include AlgoliaSearch

  delegate :latitude, :longitude, to: :addresses, prefix: true, allow_nil: true

  enum status: { pending: 0, approved: 1, rejected: 2, inactive: 3 }

  enum source_attribution: { ask_darcel: 0, service_net: 1 }

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many(:sites,
                          join_table: "resources_sites",
                          foreign_key: "resource_id")
  has_many :addresses, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :change_requests, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :feedbacks, dependent: :destroy

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :schedule
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :phones

  before_create do
    self.status = :pending unless status
  end

  if Rails.configuration.x.algolia.enabled
    # NOTE: We can't use the per_environment option because both our production
    # and staging servers use the same RAILS_ENV.

    # Important: Use Resource.reindex! and Service.reindex! to reindex/create your index
    # rubocop:disable Metrics/BlockLength
    algoliasearch if: :approved?,
                  index_name: "#{Rails.configuration.x.algolia.index_prefix}_services_search",
                  id: :algolia_id do
      # specify the list of attributes available for faceting
      attributesForFaceting %i[categories open_times eligibilities associated_sites type]
      # Define attributes used to build an Algolia record
      add_attribute :_geoloc do
        if addresses.any?
          { lat: addresses[0].latitude.to_f, lng: addresses[0].longitude.to_f }
        else
          { lat: 0, lng: 0 }
        end
      end

      add_attribute :status

      add_attribute :addresses do
        if addresses.present?
          addresses.map do |a|
            {
              city: a.city,
              state_province: a.state_province,
              postal_code: a.postal_code,
              country: 'USA',
              address_1: a.address_1,
              latitude: a.latitude.to_f || nil,
              longitude: a.longitude.to_f || nil
            }
          end
        else
          []
        end
      end

      add_attribute :schedule do
        unless schedule.nil? # rubocop:disable Style/SafeNavigation
          schedule.schedule_days.map do |s|
            { opens_at: s.opens_at, closes_at: s.closes_at, day: s.day }
          end
        end
      end

      add_attribute :open_times do
        schedule&.algolia_open_times
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

      add_attribute :is_mohcd_funded

      add_attribute :services do
        services.map do |s|
          { name: s.name }
        end
      end

      add_attribute :phones do
        phones.map do |p|
          { number: p.number, service_type: p.service_type }
        end
      end

      add_attribute :associated_sites do
        sites.map(&:site_code)
      end
    end
    # rubocop:enable Metrics/BlockLength
    puts algoliasearch.inspect
  end

  def resource_id
    id
  end

  def type
    "resource"
  end

  def is_mohcd_funded # rubocop:disable Naming/PredicateName
    categories.any? { |category| category['name'] == 'MOHCD Funded' }
  end

  private

  def algolia_id
    "resource_#{id}" # ensure the resource & service IDs are not conflicting
  end
end
