class RatingsController < ApplicationController
  def create
    rating = Rating.new(rating: request['rating'], service_id: params[:service_id], resource_id: params[:resource_id], user_id: 1)
    Review.create(rating: rating, review: request['review'])
  end
end
