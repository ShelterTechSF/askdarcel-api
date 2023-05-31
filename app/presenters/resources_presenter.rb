# frozen_string_literal: true

class ResourcesPresenter < Jsonite
  property :updated_at
  property :alternate_name
  property :certified
  property :email
  property :id
  property :legal_status
  property :long_description
  property :name
  property :short_description
  property :status
  property :verified_at
  property :website
  property :certified_at
  property :featured
  property :source_attribution
  property :internal_note
  property(:services) do
    # Filter services in Ruby to avoid ignoring prefetched rows and generating
    # a new query.
    approved_services = services.select(&:approved?)
    ServicesPresenter.present(approved_services)
  end
  property :schedule, with: SchedulesPresenter
  property :phones, with: PhonesPresenter
  property :addresses, with: AddressPresenter
  property :notes, with: NotesPresenter
  property :categories, with: CategoryPresenter
  # property :programs, with: ProgramsPresenter
end
