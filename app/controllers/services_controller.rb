class ServicesController < ApplicationController
  def create
    render status: :accepted
  end

  def pending
    if !admin_signed_in?
      render status: :unauthorized
    else
      render json: ServicesPresenter.present(services.pending)
    end
  end

  def services
    Service.includes(:notes, { schedule: :schedule_days })
  end

  def approve
    if !admin_signed_in?
      render status: :unauthorized
    else
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
  end

  def reject
    if !admin_signed_in?
      render status: :unauthorized
    else
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
  end

  def service_params
    @service_params ||= params.require(:service)
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end

end
