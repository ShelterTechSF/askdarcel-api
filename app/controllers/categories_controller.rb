class CategoriesController < ApplicationController
  before_action :cachable

  def index
    render json: CategoryPresenter.present(Category.all)
  end
end
