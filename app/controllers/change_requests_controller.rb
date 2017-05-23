class ChangeRequestsController < ApplicationController
  def create
    if params[:resource_id]
      @change_request = ResourceChangeRequest.create(object_id: params[:resource_id], resource_id: params[:resource_id])
    elsif params[:service_id]
      @change_request = ServiceChangeRequest.create(object_id: params[:service_id], resource_id: Service.find(params[:service_id]).resource_id)
    elsif params[:address_id]
      @change_request = AddressChangeRequest.create(object_id: params[:address_id], resource_id: Address.find(params[:address_id]).resource_id)
    elsif params[:phone_id]
      @change_request = PhoneChangeRequest.create(object_id: params[:phone_id], resource_id: Phone.find(params[:phone_id]).resource_id)
    elsif params[:schedule_day_id]
      schedule = Schedule.find(ScheduleDay.find(params[:schedule_day_id]).schedule_id)
      if (schedule.resource_id)
        @change_request = ScheduleDayChangeRequest.create(object_id: params[:schedule_day_id], resource_id: schedule.resource_id)
      else 
        @change_request = ScheduleDayChangeRequest.create(object_id: params[:schedule_day_id], resource_id: Service.find(schedule.service_id).resource_id)
      end         
    elsif params[:note_id]
      note = Note.find(params[:note_id])
      if (note.resource_id)
        @change_request = NoteChangeRequest.create(object_id: params[:note_id], resource_id: note.resource_id)
      else
        @change_request = NoteChangeRequest.create(object_id: params[:note_id], resource_id: Service.find(note.service_id).resource_id)
      end
    end

    @change_request.field_changes = field_changes

    render status: :created, json: ChangeRequestsPresenter.present(@change_request)
  end

  def index
    if !admin_signed_in?
      render status: :unauthorized
    else
      render json: ChangeRequestsPresenter.present(changerequest.pending)
    end
  end

  def approve
    if !admin_signed_in?
      render status: :unauthorized
    else
      change_request = ChangeRequest.find params[:change_request_id]
      if change_request.pending?

        FieldChange.delete_all(["change_request_id = ?", change_request.id])

        change_request.field_changes = field_changes_approve change_request.id

        change_request.save!

        persist_change change_request
        change_request.approved!
        render status: :ok
      elsif change_request.approved?
        render status: :not_modified
      else
        render status: :precondition_failed
      end
    end
  end

  def replace_field_changes(change_request)



    return change_request
  end

  def reject
    if !admin_signed_in?
      render status: :unauthorized
    else
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
  end

  private

  def persist_change(change_request)
    object_id = change_request.object_id
    puts object_id

    if change_request.is_a? ServiceChangeRequest
      puts 'ServiceChangeRequest'
      service = Service.find(change_request.object_id)
      field_change_hash = get_field_change_hash change_request
      service.update field_change_hash
    elsif change_request.is_a? ResourceChangeRequest
      puts 'ResourceChangeRequest'
      resource = Resource.find(change_request.object_id)
      field_change_hash = get_field_change_hash change_request
      resource.update field_change_hash
    elsif change_request.is_a? ScheduleDayChangeRequest
      puts 'ScheduleDayChangeRequest'
      schedule_day = ScheduleDay.find(change_request.object_id)
      field_change_hash = get_field_change_hash change_request
      schedule_day.update field_change_hash
    elsif change_request.is_a? NoteChangeRequest
      puts 'NoteChangeRequest'
      note = Note.find(change_request.object_id)
      field_change_hash = get_field_change_hash change_request
      note.update field_change_hash
    elsif change_request.is_a? PhoneChangeRequest
      puts 'PhoneChangeRequest'
      phone = Phone.find(change_request.object_id)
      field_change_hash = get_field_change_hash change_request
      phone.update field_change_hash
    elsif change_request.is_a? AddressChangeRequest
      puts 'AddressChangeRequest'
      address = Address.find(change_request.object_id)
      field_change_hash = get_field_change_hash change_request
      address.update field_change_hash
    else
      puts 'invalid request'
    end
  end

  def get_field_change_hash(change_request)
    field_change_hash = {}

    change_request.field_changes.each do |field_change|
      puts field_change.field_name
      puts field_change.field_value
      field_change_hash[field_change.field_name] = field_change.field_value
    end
    field_change_hash
  end

  def field_changes
    params[:change_request].map do |fc|
      field_change_hash = {}
      field_change_hash[:field_name] = fc[0]
      field_change_hash[:field_value] = fc[1]
      field_change_hash[:change_request_id] = @change_request.id
      FieldChange.create(field_change_hash)
    end
  end

  def field_changes_approve(change_request_id)
    params[:change_request].map do |fc|
      field_change_hash = {}
      field_change_hash[:field_name] = fc[0]
      field_change_hash[:field_value] = fc[1]
      field_change_hash[:change_request_id] = change_request_id
      FieldChange.create(field_change_hash)
    end
  end


  def changerequest
    ChangeRequest.includes(:field_changes, resource: [
                             :address, :phones, :categories, :notes,
                             schedule: :schedule_days,
                             services: [:notes, :categories, { schedule: :schedule_days }],
                             ratings: [:review]])
  end
end
