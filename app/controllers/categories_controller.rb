# frozen_string_literal: true

class CategoriesController < ApplicationController
  def show
    category = Category.find(params[:id])
    render json: CategoryPresenter.present(category)
  end

  def subcategories
    categories = Category.where("id in (select child_id from category_relationships where parent_id=?)", params[:id])
    render json: CategoryPresenter.present(categories)
  end

  def index
    # categories = Category.order(:name)
    # Cast:
    #   nil and '' -> nil
    #   '0', 'false', 'False', 'f', etc. -> false
    #   Almost everything else -> true
    categories = if params[:site_id]
                   Site.find(params[:site_id]).categories
                 else
                   Site.find(0).categories #sfsg
                 end

    top_level = ActiveRecord::Type::Boolean.new.cast(params[:top_level])
    categories = categories.where(top_level: top_level) unless top_level.nil?
    render json: CategoryPresenter.present(categories)
  end

  def counts
    render status: :ok, json:
        Category.order(:name).map { |c|
          { name: c.name,
            services: c.services.where('status' => 1).count,
            resources: c.resources.where('status' => 1).count }
        }
  end

  def featured
    categories = Category.where(featured: true)
    render json: CategoryPresenter.present(categories)
  end
end
