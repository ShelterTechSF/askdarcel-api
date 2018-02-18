# frozen_string_literal: true

class Note < ActiveRecord::Base
  belongs_to :resource, touch: true
  belongs_to :service
end
