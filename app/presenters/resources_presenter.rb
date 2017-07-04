class ResourcesPresenter < Jsonite
  property :id
  property :name
  property :short_description
  property :long_description
  property :website
  property :verified_at
  property :email
  property :status
  property(:services) do
    # Filter services in Ruby to avoid ignoring prefetched rows and generating
    # a new query.
    approved_services = services.select(&:approved?)
    ServicesPresenter.present(approved_services)
  end
  property :schedule, with: SchedulesPresenter
  property :phones, with: PhonesPresenter
  property :address, with: AddressPresenter
  property :notes, with: NotesPresenter
  property :categories, with: CategoryPresenter
  property :ratings, with: RatingPresenter
end
