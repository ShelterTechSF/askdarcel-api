# frozen_string_literal: true

class Address < ActiveRecord::Base
  acts_as_mappable distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude
  belongs_to :resource, touch: true
end
