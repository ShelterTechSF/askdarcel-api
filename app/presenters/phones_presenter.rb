# frozen_string_literal: true

class PhonesPresenter < Jsonite
  property :id
  property(:number) { Phonelib.parse(number).national }
  property(:extension) { Phonelib.parse(number).extension.presence }
  property :service_type
  property(:country_code) { Phonelib.parse(number).country }
end
