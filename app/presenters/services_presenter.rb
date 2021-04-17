# frozen_string_literal: true

class ServicesPresenter < Jsonite
  property :updated_at
  property :alternate_name
  property :application_process
  property :certified
  property :eligibility
  property :email
  property :fee
  property :id
  property :interpretation_services
  property :long_description
  property :name
  property :required_documents
  property :url
  property :verified_at
  property :wait_time
  property :certified_at
  property :featured
  property :source_attribution
  property :schedule, with: SchedulesPresenter
  property :notes, with: NotesPresenter
  property :categories, with: CategoryPresenter
  property :addresses, with: AddressPresenter
  property :eligibilities, with: EligibilityPresenter
end
