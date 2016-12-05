class ChangerequestsController < ApplicationController
  def create
    if params[:resource_id]
      change_request = ResourceChangeRequest.create(object_id: params[:resource_id])
    elsif params[:service_id]
      change_request = ServiceChangeRequest.create(object_id: params[:service_id])
    end

    render status: :created, json: ChangeRequestsPresenter.present(change_request)
  end

  def index
    render json: ChangeRequestsPresenter.present(changerequest.pending)
  end

  def approve
    change_request = ChangeRequest.find params[:changerequest_id]
    change_request.approved!
    render status: :ok
  end

  def reject
    change_request = ChangeRequest.find params[:changerequest_id]
    change_request.rejected!
    render status: :ok
  end

  private

  def changerequest
    ChangeRequest.includes(:field_changes)
  end
end
