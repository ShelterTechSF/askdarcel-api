# frozen_string_literal: true

class DocumentsController < ApplicationController
  def create
    document = params[:document]
    persisted_document = Document.create(url: document[:url], name: document[:name], description: document[:description])

    service = Service.find_by_id(document[:service_id])

    service.documents << persisted_document
    service.save

    render status: :created, json: DocumentPresenter.present(persisted_document)
  end

  def update
    document = Document.find(params[:id])
    document.url = params[:document][:url]
    document.name = params[:document][:name]
    document.description = params[:document][:description]

    document.save

    render status: :ok, json: DocumentPresenter.present(document)
  end

  def destroy
    document = Document.find params[:id]
    document.delete

    render status: :ok
  end
end
