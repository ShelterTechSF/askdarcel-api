# frozen_string_literal: true

class ResourcesController < ApplicationController
  def index
    category_id = params.require :category_id

    relation = get_all_resources(category_id)
    render json: ResourcesPresenter.present(relation)
  end

  def show
    resource = resources.find(params[:id])
    render json: ResourcesPresenter.present(resource)
  end

  def create
    resources = clean_resources_params.map { |r| Resource.new(r) }
    fix_resources(resources)
    return render_bad_request(resources) if resources.any?(&:invalid?)

    Resource.transaction { resources.each(&:save!) }
    render status: :created, json: { resources: resources.map { |r| ResourcesPresenter.present(r) } }
    update_in_airtable(resources[0])
  end

  def certify
    resource = Resource.find params[:resource_id]

    resource.certified = true
    resource.certified_at = Time.now
    resource.save!
    update_in_airtable(resource)
    render status: :ok
  end

  def destroy
    resource = Resource.find params[:id]
    if resource.approved?
      resource.inactive!
      update_in_airtable(resource)
      remove_from_algolia(resource)
      render status: :ok
    else
      render status: :precondition_failed
    end
  end

  # Return the total number of active (i.e., approved) resources
  def count
    render status: :ok, json: Resource.approved.count
  end

  private

  def get_all_resources(category_id)
    relation = if category_id == "all"
                 resources.where(status: Resource.statuses[:approved])
               else
                 # TODO: This can be simplified once we remove categories from resources
                 resources
                   .joins(:addresses)
                   .where(categories_join_string, category_id, category_id)
                   .where(status: Resource.statuses[:approved])
                   .order(sort_order)
               end
    relation
  end

  # Clean raw request params for interoperability with Rails APIs.
  def clean_resources_params
    resources_params = params.require(:resources).map { |r| permit_resource_params(r) }

    resources_params.each { |r| transform_resource_params!(r) }
  end

  def fix_resources(resources)
    resources.each do |r|
      r.status = :approved
      r.addresses.each do |a|
        fix_lat_and_long(a)
      end

      if r.sites.length.zero?
        sfsg = Site.find_by site_code: "sfsg"
        r.sites = [sfsg]
      end
    end
  end

  def render_bad_request(resources)
    render status: :bad_request, json: { resources: resources.select(&:invalid?).map(&:errors) }
  end

  def remove_from_algolia(resource)
    resource.remove_from_index!
  rescue StandardError
    puts 'failed to remove resource ' + resource.id.to_s + ' from algolia index'
  end

  def fix_lat_and_long(address)
    geo_code(address)
  rescue StandardError => e
    puts 'google geocoding failed for new address ' + address.address_1 + ': ' + e.message
  end

  def geo_code(address)
    a = Geokit::Geocoders::GoogleGeocoder.geocode address.address_1 + ',' + address.city + ',' + address.state_province
    address.latitude = a.latitude
    address.longitude = a.longitude
  end

  # Filter out all the attributes that are unsafe for users to set, including
  # all :id keys besides category ids.
  def permit_resource_params(resource_params) # rubocop:disable Metrics/MethodLength
    resource_params.permit(
      :name,
      :long_description,
      :short_description,
      :website,
      :email,
      :status,
      addresses: %i[{ address_1 address_2 address_3 address_4 city state_province country postal_code latitude longitude }],
      schedule: [{ schedule_days: %i[day opens_at closes_at open_day open_time close_day close_time] }],
      phones: %i[number service_type],
      notes: [:note],
      categories: [:id],
      sites: [:id]
    )
  end

  # Transform parameters for creating a single resource in-place.
  #
  #
  # This method transforms all keys representing nested objects into
  # #{key}_attribute.
  def transform_resource_params!(resource)
    if resource.key? :schedule
      schedule = resource[:schedule_attributes] = resource.delete(:schedule)
      schedule[:schedule_days_attributes] = schedule.delete(:schedule_days) if schedule.key? :schedule_days
    end

    resource['category_ids'] = resource.delete(:categories).collect { |h| h[:id] } if resource.key? :categories

    resource['site_ids'] = resource.delete(:sites).collect { |h| h[:id] } if resource.key? :sites

    transform_simple_objects resource
  end

  def transform_simple_objects(resource)
    resource[:notes_attributes] = resource.delete(:notes) if resource.key? :notes

    resource[:addresses_attributes] = resource.delete(:addresses) if resource.key? :addresses

    resource.delete(:notes)

    resource[:phones_attributes] = resource.delete(:phones) if resource.key? :phones
  end

  def resources
    # Note: We *must* use #preload instead of #includes to force Rails to make a
    # separate query per table. Otherwise, it creates one large query with many
    # joins, which amplifies the amount of data being sent between Rails and the
    # DB by several orders of magnitude due to duplication of tuples.
    Resource.preload(:addresses, :phones, :categories, :notes, :sites,
                     schedule: :schedule_days,
                     services: [:notes, :categories, { schedule: :schedule_days }, :eligibilities])
  end

  def sort_order
    @sort_order ||= lat_lng ? Address.distance_sql(lat_lng) : :id
  end

  def lat_lng
    return @lat_lng if defined? @lat_lng

    @lat_lng ||= Geokit::LatLng.new(params[:lat], params[:long]) if params[:lat] && params[:long]
  end

  def categories_join_string
    <<~'SQL'
      resources.id IN (
        (
          SELECT resources.id
            FROM resources
            INNER JOIN categories_resources ON resources.id = categories_resources.resource_id
            WHERE categories_resources.category_id = ?
        ) UNION (
          SELECT resources.id
            FROM resources
            INNER JOIN services ON resources.id = services.resource_id
            INNER JOIN categories_services ON services.id = categories_services.service_id
            WHERE categories_services.category_id = ?
        )
      )
    SQL
  end
end
