class CategoriesController < ApplicationController
  def index
    categories = Category.order(:name)
    # Cast:
    #   nil and '' -> nil
    #   '0', 'false', 'False', 'f', etc. -> false
    #   Almost everything else -> true
    top_level = ActiveRecord::Type::Boolean.new.cast(params[:top_level])
    categories = categories.where(top_level: top_level) unless top_level.nil?
    render json: CategoryPresenter.present(categories)
  end

  # rubocop:disable Metrics/AbcSize
  def counts
    if !admin_signed_in?
      render status: :unauthorized
    else
      render status: :ok, json:
          Category.order(:name).map { |c|
            { name: c.name,
              services: Service.joins(:categories).where('categories.id' => c.id).where('status' => 1).count,
              resources: Resource.joins(:categories).where('categories.id' => c.id).where('status' => 1).count }
          }
    end
  end
  # rubocop:enable Metrics/AbcSize
end
