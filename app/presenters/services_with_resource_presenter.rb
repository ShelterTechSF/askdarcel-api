# frozen_string_literal: true

class ServicesWithResourcePresenter < ServicesPresenter
  property :resource, with: ResourcesPresenter
  property :program, with: ProgramsPresenter
end
