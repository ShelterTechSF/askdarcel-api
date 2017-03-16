class ServicesController < ApplicationController
  before_action :require_admin_signed_in!, except: [:create]

  def create
    render status: :accepted
  end

  def show
    render json: ServicesPresenter.present(services.pending)
  end

  def approve
    service = Service.find params[:service_id]
    if service.pending?
      service.approved!
      render status: :ok
    elsif service.approved?
      render status: :not_modified
    else
      render status: :precondition_failed
    end
  end

  def reject
    service = Service.find params[:service_id]
    if service.pending?
      service.rejected!
      render status: :ok
    elsif service.rejected?
      render status: :not_modified
    else
      render status: :precondition_failed
    end
  end

  private

  def services
    Service.includes(:notes, schedule: :schedule_days)
  end

  def service_params
    @service_params ||= params.require(:service)
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end
end
