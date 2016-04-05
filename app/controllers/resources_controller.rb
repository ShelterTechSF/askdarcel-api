class ResourcesController < ApplicationController
  def index
    category_id = params[:category_id]
    resources = if category_id
                  Resource.joins(:categories).where('categories.id' => category_id)
                else
                  Resource.all
                end

    render json: resources.to_json(include: ['addresses', 'phones', { schedule: { include: 'schedule_days' } }])
  end

  def show
    resource = Resource.find(params[:id])
    render json: resource.to_json(include: ['addresses', 'phones', { schedule: { include: 'schedule_days' } }])
  end
end
