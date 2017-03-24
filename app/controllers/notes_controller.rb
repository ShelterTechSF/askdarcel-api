class NotesController < ApplicationController
  def create

    if params[:service_id]
      note = service.notes.build
      note.note = params[:note][:note]
      service.save!
    elsif params[:resource_id]
      note = resource.notes.build
      note.note = params[:note][:note]
      resource.save!
    end

    render status: :created, json: note
  end

  private

  def service
    @service ||= Service.find params[:service_id] if params[:service_id]
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end
end
