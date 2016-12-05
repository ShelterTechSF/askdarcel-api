class ServicesPresenter < Jsonite
  property :id
  property :name
  property :long_description
  property :eligibility
  property :required_documents
  property :fee
  property :application_process
  property :schedule, with: SchedulesPresenter
  property :notes, with: NotesPresenter
end
