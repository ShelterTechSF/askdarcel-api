# frozen_string_literal: true

class Keyword < ActiveRecord::Base
  has_and_belongs_to_many :resources
  has_and_belongs_to_many :services
  has_and_belongs_to_many :categories
end
