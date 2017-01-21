class ChangeRequestsPresenter < Jsonite
  property :id
  property :status
  property :type
  property :object_id
  property :field_changes, with: FieldChangesPresenter
  property :resource, with: ResourcesPresenter
end
