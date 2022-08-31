# frozen_string_literal: true

class ServiceDocument < ActiveRecord::Base
  belongs_to :service
  belongs_to :document
end
