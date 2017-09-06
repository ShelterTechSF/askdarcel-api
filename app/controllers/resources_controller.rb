class ResourcesController < ApplicationController
  before_action :cachable

  def index
    category_id = params.require :category_id
    relation = resources.joins(:categories).joins(:address)
                        .where('categories.id' => category_id).where(status: Resource.statuses[:approved])
    .order(sort_order)
    render json: ResourcesPresenter.present(relation.approved)
  end

  def show
    resource = resources.find(params[:id])
    render json: ResourcesPresenter.present(resource)
  end

  def search
    result = Resources::Search.perform(params.require(:query), sort_order, scope: resources)
    render json: ResourcesPresenter.present(result)
  end

  def create
    resources_params = clean_resources_params
    resources = resources_params.map { |r| Resource.new(r) }
    if resources.any?(&:invalid?)
      render status: :bad_request, json: { resources: resources.select(&:invalid?).map(&:errors) }
    else
      Resource.transaction { resources.each(&:save!) }

      render status: :created, json: { resources: resources.map { |r| ResourcesPresenter.present(r) } }
    end
  end

  private

  # Clean raw request params for interoperability with Rails APIs.
  def clean_resources_params
    resources_params = params.require(:resources).map { |r| permit_resource_params(r) }

    resources_params.each { |r| transform_resource_params!(r) }
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
      schedule: [{ schedule_days: [:day, :opens_at, :closes_at] }],
      notes: [:note],
      categories: [:id]
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

    resource[:notes_attributes] = resource.delete(:notes) if resource.key? :notes

    resource.delete(:notes)

    resource['category_ids'] = resource.delete(:categories).collect { |h| h[:id] } if resource.key? :categories
  end

  def resources
    Resource.includes(:address, :phones, :categories, :notes,
                      schedule: :schedule_days,
                      services: [:notes, :categories, { schedule: :schedule_days }],
                      ratings: [:review])
  end

  def sort_order
    @sort_order ||= if lat_lng
                      Address.distance_sql(lat_lng)
                    else
                      :id
                    end
  end

  def lat_lng
    return @lat_lng if defined? @lat_lng
    @lat_lng = if params[:lat] && params[:long]
                 Geokit::LatLng.new(params[:lat], params[:long])
               end
  end
end
