class ChangeRequestsController < ApplicationController
  def create
    if params[:resource_id]
      @change_request = ResourceChangeRequest.create(object_id: params[:resource_id])
    elsif params[:service_id]
      @change_request = ServiceChangeRequest.create(object_id: params[:service_id])
    elsif params[:address_id]
      @change_request = AddressChangeRequest.create(object_id: params[:address_id])
    elsif params[:phone_id]
      @change_request = PhoneChangeRequest.create(object_id: params[:phone_id])
    elsif params[:schedule_day_id]
      @change_request = ScheduleDayChangeRequest.create(object_id: params[:schedule_day_id])
    elsif params[:note_id]
      @change_request = NoteChangeRequest.create(object_id: params[:note_id])
    end

    @change_request.field_changes = field_changes

    render status: :created, json: ChangeRequestsPresenter.present(@change_request)
  end

  def index
    render json: ChangeRequestsPresenter.present(changerequest.pending)
  end

  def approve
    change_request = ChangeRequest.find params[:change_request_id]
    change_request.approved!
    render status: :ok
  end

  def reject
    change_request = ChangeRequest.find params[:change_request_id]
    if change_request.pending?
      change_request.rejected!
      render status: :ok
    elsif change_request.rejected?
      render status: :not_modified
    else
      render status: :precondition_failed
    end
  end

  private

  def field_changes
    params[:change_request].map do |fc|
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
