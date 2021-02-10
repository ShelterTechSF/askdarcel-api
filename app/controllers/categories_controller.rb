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
    categories = Category.order(:name)
    # Cast:
    #   nil and '' -> nil
    #   '0', 'false', 'False', 'f', etc. -> false
    #   Almost everything else -> true
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

  def hierarchy
    json_obj = {:categories => []}
    # Find all top level categories
    categories = Category.where(top_level: true)
    categories.each do |cat|
      # Find children of the top level categories
      # Present the top level categories with an additional field: "children", which is an array of children categories
      category_children = Category.where("id in (select child_id from category_relationships where parent_id=?)", cat.id)
      cat_json = CategoryPresenter.present(cat)
      cat_json[:children] = []
      category_children.each do |child|
        cat_json[:children].append(CategoryPresenter.present(child))
      end
      json_obj[:categories].append(cat_json)
    end
    render json: json_obj
  end

end
