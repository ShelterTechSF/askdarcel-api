# frozen_string_literal: true

class EligibilitiesController < ApplicationController
  def index
    eligibilities = Eligibility.order(:name)

    render json: EligibilityPresenter.present(eligibilities)
  end
end
