class ServicesPresenter < Jsonite
  property :id
  property :name
  property :long_description
  property :eligibility
  property :required_documents
  property :fee
  property :application_process
  property :verified_at
  property :email
  property :certified
  property :schedule, with: SchedulesPresenter
  property :notes, with: NotesPresenter
  property :categories, with: CategoryPresenter
  property :addresses, with: AddressPresenter
  property :eligibilities, with: EligibilityPresenter
end
