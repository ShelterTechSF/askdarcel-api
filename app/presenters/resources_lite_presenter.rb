# frozen_string_literal: true

# Omit some redundant information while presenting subojects
# e.g. services.
class ResourcesLitePresenter < Jsonite
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
  property :schedule, with: SchedulesPresenter
  property :phones, with: PhonesPresenter
  property :addresses, with: AddressPresenter
  property :notes, with: NotesPresenter
end
