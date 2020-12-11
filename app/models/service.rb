# frozen_string_literal: true

class Service < ActiveRecord::Base
  include AlgoliaSearch

  enum status: { pending: 0, approved: 1, rejected: 2, inactive: 3 }

  enum source_attribution: { ask_darcel: 0, service_net: 1 }

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

  has_many :textings

  before_create do
    self.status = :pending unless status
  end

  if Rails.configuration.x.algolia.enabled
    # Note: We can't use the per_environment option because both our production
    # and staging servers use the same RAILS_ENV.
    # rubocop:disable Metrics/BlockLength
    algoliasearch index_name: "#{Rails.configuration.x.algolia.index_prefix}_services_search", id: :algolia_id do
      # specify the list of attributes available for faceting
      attributesForFaceting %i[categories open_times eligibilities]

      # Define attributes used to build an Algolia record
      add_attribute :status
      add_attribute :_geoloc do
        if addresses.any?
          addresses.map do |a|
            { lat: a.latitude.to_f, lng: a.longitude.to_f } \
              if a.latitude.present? && a.longitude.present?
          end
        elsif !resource.addresses.blank? && resource.addresses[0].latitude.present? && resource.addresses[0].longitude.present?
          { lat: resource.addresses[0].latitude.to_f, lng: resource.addresses[0].longitude.to_f }
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
              address_1: a.address_1,
              latitude: a.latitude.to_f || nil,
              longitude: a.longitude.to_f || nil
            }
          end
        elsif resource.addresses.present?
          resource.addresses.map do |a|
            {
              city: a.city,
              state_province: a.state_province,
              postal_code: a.postal_code,
              country: a.country,
              address_1: a.address_1,
              latitude: a.latitude.to_f || nil,
              longitude: a.longitude.to_f || nil
            }
          end
        end
      end
      add_attribute :schedule do
        if schedule.nil?
          if resource.schedule.present?
            resource.schedule.schedule_days.map do |s|
              { opens_at: s.opens_at, closes_at: s.closes_at, day: s.day }
            end
          end
        else
          schedule.schedule_days.map do |s|
            { opens_at: s.opens_at, closes_at: s.closes_at, day: s.day }
          end
        end
      end

      add_attribute :open_times do
        if use_resource_schedule
          resource.schedule&.algolia_open_times
        else
          schedule.algolia_open_times
        end
      end

      add_attribute :resource_schedule do
        if resource.schedule.present?
          resource.schedule.schedule_days.map do |s|
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

      add_attribute :is_mohcd_funded

      add_attribute :categories do
        categories.map(&:name)
      end

      add_attribute :use_resource_schedule

      add_attribute :eligibilities do
        eligibilities.map(&:name)
      end

      add_attribute :phones do
        # Currently there's no relationship between Services -> Phones, only
        # Resources <-> Phones. Even though the DB schema currently has a
        # foreign key between Phone and Service, the has_many association hasn't
        # been declared, and we don't have a user-facing edit page which exposes
        # this anyway, so we'd have to re-vet the data to fill in this
        # information anyway.
        #
        # Therefore, this just grabs the resource's phone numbers.
        resource.phones.map do |p|
          { number: p.number, service_type: p.service_type }
        end
      end

      # add_attribute :keywords do
      #   keywords.map(&:name)
      # end
    end
    # rubocop:enable Metrics/BlockLength
  end

  def service_of
    resource.name
  end

  def service_id
    id
  end

  def is_mohcd_funded # rubocop:disable Naming/PredicateName
    categories.any? { |category| category['name'] == 'MOHCD Funded' }
  end

  def type
    "service"
  end

  def use_resource_schedule
    return true if schedule.nil?

    schedule.schedule_days.empty?
  end

  private

  def algolia_id
    "service_#{id}"
  end
end
