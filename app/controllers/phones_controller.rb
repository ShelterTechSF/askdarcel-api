# frozen_string_literal: true

class PhonesController < ApplicationController
  def index
    category_id = params.require :category_id

    relation = get_all_resources(category_id)
    render json: PhonesPresenter.present(relation)
  end

  def show
    resource = Phone.find([params[:id]])
    render json: PhonesPresenter.present(resource)
  end

  def get_all_resources(category_id)
    relation = if category_id == "all"
                  phones.where(status: Phone.statuses[:approved])
               else
                 # TODO: This can be simplified once we remove categories from resources
                 phones
                   .joins(:addresses)
                   .where(categories_join_string, category_id, category_id)
                   .where(status: Phone.statuses[:approved])
                   .order(sort_order)
               end
    relation
  end

  def destroy
    phone = Phone.find params[:id]
    phone.delete
  end

  def phones
    # Note: We *must* use #preload instead of #includes to force Rails to make a
    # separate query per table. Otherwise, it creates one large query with many
    # joins, which amplifies the amount of data being sent between Rails and the
    # DB by several orders of magnitude due to duplication of tuples.
    Phone.preload(:phones [:categories])
  end

  def categories_join_string
    <<~'SQL'
      phones.id IN (
        (
          SELECT resources.id
            FROM resources
            INNER JOIN categories_resources ON resources.id = categories_resources.resource_id
            WHERE categories_resources.category_id = ?
        ) UNION (
          SELECT resources.id
            FROM resources
            INNER JOIN services ON resources.id = services.resource_id
            INNER JOIN categories_services ON services.id = categories_services.service_id
            WHERE categories_services.category_id = ?
        )
      )
    SQL
  end
end
