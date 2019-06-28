# frozen_string_literal: true

class RatingsController < ApplicationController
  def create
    if params[:resource_id]
      rating = resource.ratings.create!(rating_params)
    elsif params[:service_id]
      rating = service.ratings.create!(rating_params)
    end

    render status: :created, json: RatingPresenter.present(rating)
  end

  private

  def rating_params
    @rating_params ||= params.require(:rating).permit(:rating).merge(user: current_user, review: review)
  end

  def review
    @review ||= Review.new params.require(:rating).permit(:review)
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end

  def service
    @service ||= Service.find params[:service_id] if params[:service_id]
  end
end
