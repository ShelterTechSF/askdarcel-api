class ResourcesPresenter < Jsonite
  property :id
  property :name
  property :short_description
  property :long_description
  property :website
  property :verified_at
  property :services, with: ServicesPresenter
  property :schedule, with: SchedulesPresenter
  property :phones, with: PhonesPresenter
  property :address, with: AddressPresenter
  property :notes, with: NotesPresenter
  property :categories, with: CategoryPresenter
  property :ratings, with: RatingPresenter
end
