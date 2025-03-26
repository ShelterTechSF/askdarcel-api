class OrganizationsPresenter < Jsonite
  property :id
  property :name
  property :alternate_name
	property(:description) { long_description }
  property :email
  property(:url) { website }
  property(:tax_status){ nil }
  property(:tax_id){ nil }
  property(:year_incorporated){ nil }
  property :legal_status
end
