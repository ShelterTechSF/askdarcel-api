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
    render json: ChangeRequestsPresenter.present(change_request.pending)
  end

  def approve
    puts 'HARRO!'
    change_request = ChangeRequest.find params[:changerequest_id]
    persist_change change_request
    change_request.approved!
    render status: :ok
  end

  def reject
    change_request = ChangeRequest.find params[:changerequest_id]
    change_request.rejected!
    render status: :ok
  end

  private

  def persist_change(change_request)
    if change_request.is_a? 'ResourceChangeRequest'
      puts 'its a resource change request!'
    else
      puts 'it isnt!'
    end
  end

  def field_changes
    params[:changerequest][:field_changes].map do |fc|
      field_change_hash = {}
      field_change_hash[:field_name] = fc[:field_name]
      field_change_hash[:field_value] = fc[:field_value]
      field_change_hash[:change_request_id] = @change_request.id
      FieldChange.create(field_change_hash)
    end
  end

  def change_request
    ChangeRequest.includes(:field_changes, :resource)
  end
end
