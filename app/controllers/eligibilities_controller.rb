# frozen_string_literal: true

class EligibilitiesController < ApplicationController
  # GET /eligibilities
  #
  # Return all eligibilities sorted by name in ascending order.
  def index
    eligibilities = Eligibility.order(:name)

    render json: EligibilityPresenter.present(eligibilities)
  end

  # GET /eligibilities/:id
  #
  # @param :id [ Integer ] id of eligibility to show
  def show
    eligibility = Eligibility.find(params[:id])

    render json: EligibilityPresenter.present(eligibility)
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found, json: { error: e.message }
  end

  # PUT /eligibilities/:id
  #
  # @param :id [ Integer ] id of eligibility to update
  # @param :name [ String, Optional ] new name for this eligibility
  # @param :feature_rank [ Integer or nil, Optional ] new feature_rank for this
  # eligibility.
  def update
    eligibility = Eligibility.find(params[:id])

    eligibility.update!(params.permit(:name, :feature_rank))

    render json: EligibilityPresenter.present(eligibility)
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordNotUnique,
         ActiveRecord::RecordInvalid => e
    render_update_error(e)
  end

  # GET /eligibilities/featured
  #
  # Returns featured eligibilities sorted by `feature_rank`. In addition,
  # returns the number of services and the number of resources associated with
  # each eligibility.
  def featured
    eligibilities = Eligibility.order(:feature_rank).where.not(feature_rank: nil).to_a
    # Compute hashes that map from eligibility_id to service counts and
    # resource counts
    # TODO(cliff): Deprecate resource counts
    service_counts, resource_counts = compute_counts(eligibilities.map(&:id))
    items = EligibilityPresenter.present(eligibilities)
    items.each do |item|
      item['service_count'] = service_counts[item['id']]
      item['resource_count'] = resource_counts[item['id']]
    end

    render json: { eligibilities: items }
  end

  private

  def render_update_error(error)
    if error.is_a?(ActiveRecord::RecordNotFound)
      render status: :not_found, json: { error: error.message }
    elsif error.is_a?(ActiveRecord::RecordNotUnique)
      error_msg = "Eligibility with name #{params[:name]} already exists"
      render status: :bad_request, json: { error: error_msg }
    elsif error.is_a?(ActiveRecord::RecordInvalid)
      render status: :bad_request, json: RecordInvalidPresenter.present(error)
    else
      render status: :internal_server_error, json: { error: 'Internal server error' }
    end
  end

  def compute_counts(eligibility_ids)
    # TODO(cliff): Deprecate resource counts
    service_counts = EligibilitiesService.where(eligibility_id: eligibility_ids).group(:eligibility_id).count
    resource_counts = Eligibilities::ResourceCounts.compute(eligibility_ids)
    [service_counts, resource_counts]
  end
end
