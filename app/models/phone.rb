# frozen_string_literal: true

class Phone < ActiveRecord::Base
  belongs_to :resource, touch: true
end
