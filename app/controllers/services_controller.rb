class ServicesController < ApplicationController
  def show
    service = Service.find(params[:id])
    render json: ServicesPresenter.present(service)
  end
end
