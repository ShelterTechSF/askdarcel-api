# frozen_string_literal: true

class CategoriesController < ApplicationController
  def show
    category = Category.find(params[:id])
    render json: CategoryPresenter.present(category)
  end

  def subcategories
    # Fetch category children records. Records are ordered by (optional) child_priority_rank
    category_relationships = CategoryRelationship.where(parent_id: params[:id])
                                                 .order(:child_priority_rank)
                                                 .select(:child_id, :child_priority_rank)

    child_ids = category_relationships.pluck(:child_id)

    # Query categories using child_ids and order by child_priority_rank
    categories = Category.joins("INNER JOIN (#{category_relationships.to_sql}) cr ON categories.id = cr.child_id")
                         .where(id: child_ids)
                         .order("cr.child_priority_rank")

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
    json_obj = { categories: [] }
    # Find all top level categories
    categories = Category.where(top_level: true)
    categories.each do |cat|
      category_json = present_category_json(cat)
      json_obj[:categories].append(category_json)
    end
    render json: json_obj
  end

  ## helper method to build out json object for a category and its children categories
  def present_category_json(category_object)
    # Find children of the top level categories
    # Present the top level categories with an additional field: "children", which is an array of children categories
    cat_json = CategoryPresenter.present(category_object)
    cat_json[:children] = []
    children = Category.where("id in (select child_id from category_relationships where parent_id=?)", category_object.id)
    children.each do |child|
      cat_json[:children].append(CategoryPresenter.present(child))
    end
  end
end
