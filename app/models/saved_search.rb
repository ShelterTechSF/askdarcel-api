# frozen_string_literal: true

class SavedSearch < ActiveRecord::Base
  belongs_to :user
end
