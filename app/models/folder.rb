# frozen_string_literal: true

class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :bookmarks
end
