# frozen_string_literal: true

class Schedule < ActiveRecord::Base
  belongs_to :resource, touch: true
  belongs_to :service
  has_many :schedule_days, dependent: :destroy

  accepts_nested_attributes_for :schedule_days
end
