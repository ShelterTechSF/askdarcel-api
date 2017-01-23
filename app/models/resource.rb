class Resource < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :keywords
  has_one :address
  has_many :phones
  has_one :schedule
  has_many :notes
  has_many :services
  has_many :ratings
  has_many :change_requests
end
