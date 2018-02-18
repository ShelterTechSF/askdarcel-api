# frozen_string_literal: true

class FieldChange < ActiveRecord::Base
  belongs_to :change_request
end
