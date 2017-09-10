class CategoriesController < ApplicationController
  def index
    render json: CategoryPresenter.present(Category.all)
  end
end
