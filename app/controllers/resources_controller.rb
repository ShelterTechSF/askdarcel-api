class ResourcesController < ApplicationController
  def index
    category_id = params[:category_id]
    resources = if category_id
                  Resource.joins(:categories).where('categories.id' => category_id)
                else
                  Resource.all
                end
    # rubocop:disable Metrics/LineLength
    render json: resources.to_json(include: ['addresses', 'phones', 'categories', 'notes', { services: { include: ['notes', { schedule: { include: 'schedule_days' } }] } }, { schedule: { include: 'schedule_days' } }])
    # rubocop:enable Metrics/LineLength
  end

  def show
    resource = Resource.find(params[:id])
    # rubocop:disable Metrics/LineLength
    render json: resource.to_json(include: ['addresses', 'phones', 'categories', 'notes', { services: { include: ['notes', { schedule: { include: 'schedule_days' } }] } }, { schedule: { include: 'schedule_days' } }])
    # rubocop:enable Metrics/LineLength
  end
end
