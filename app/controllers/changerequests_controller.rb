class ChangerequestsController < ApplicationController
  def create
    if params[:resource_id]
      @change_request = ResourceChangeRequest.create(object_id: params[:resource_id])
    elsif params[:service_id]
      @change_request = ServiceChangeRequest.create(object_id: params[:service_id])
    end

    @change_request.field_changes = field_changes

    render status: :created, json: ChangeRequestsPresenter.present(@change_request)
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

  def field_changes
    params[:changerequest].map do |fc|
      field_change_hash = {}
      field_change_hash[:field_name] = fc[0]
      field_change_hash[:field_value] = fc[1]
      field_change_hash[:change_request_id] = @change_request.id
      FieldChange.create(field_change_hash)
    end
  end

  def changerequest
    ChangeRequest.includes(:field_changes)
  end
end
