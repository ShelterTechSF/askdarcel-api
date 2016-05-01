class Service < ActiveRecord::Base
  belongs_to :resource
  has_many :notes
  has_one :schedule
end
