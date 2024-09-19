# frozen_string_literal: true

class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder
  belongs_to :resource
  belongs_to :service
end
