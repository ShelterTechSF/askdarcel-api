# frozen_string_literal: true

class ServicesWithResourcePresenter < ServicesPresenter
  property :resource, with: ResourcesPresenter
end
