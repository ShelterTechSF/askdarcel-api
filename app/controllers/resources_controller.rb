class ResourcesController < ApplicationController
  def index
    category_id = params.require :category_id
    relation = resources.joins(:categories).joins(:address)
                        .where('categories.id' => category_id)
                        .order(sort_order)
    render json: ResourcesPresenter.present(relation)
  end

  def show
    resource = resources.find(params[:id])
    render json: ResourcesPresenter.present(resource)
  end

  def search
    result = Resources::Search.perform(params.require(:query), sort_order, scope: resources)
    render json: ResourcesPresenter.present(result)
  end

  private

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
