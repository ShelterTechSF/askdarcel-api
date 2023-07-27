# frozen_string_literal: true
class NotesController < ApplicationController
  def create

    note = nil
    note_json = params[:note]
    if note_json[:service_id]
      note = Note.create(service_id: note_json[:service_id], note: note_json[:note])
      note.save!
    elsif note_json[:resource_id]
      note = Note.create(resource_id: note_json[:resource_id], note: note_json[:note])
      note.save!
    else
      render plain: "Improper Note Data", status: 400
      return
    end
 
    render status: :created, json: note
  end

  def update

    note = Note.find(params[:id])
    note.note = params[:note][:note]
    note.save

    render status: :ok, json: note

  end

  def destroy
    note = Note.find params[:id]
    note.delete
  end

  private

  def service
    @service ||= Service.find params[:service_id] if params[:service_id]
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end
end
