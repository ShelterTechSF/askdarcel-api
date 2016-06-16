class ResourcesController < ApplicationController
  def index
    category_id = params[:category_id]
    result = if category_id
               resources.joins(:categories).where('categories.id' => category_id)
             end

    if result
      render json: ResourcesPresenter.present(result)
    else
      render json: {}, status: :bad_request
    end
  end

  def show
    resource = resources.find(params[:id])
    render json: ResourcesPresenter.present(resource)
  end

  private

  def resources
    Resource.includes(:addresses, :phones, :categories, :notes, schedule: :schedule_days,
                                                                services: [:notes, { schedule: :schedule_days }])
  end
end
