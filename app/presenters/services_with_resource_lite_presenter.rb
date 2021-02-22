# frozen_string_literal: true

class ServicesWithResourceLitePresenter < ServicesPresenter
  property :resource, with: ResourcesLitePresenter
  property :program, with: ProgramsPresenter
end
