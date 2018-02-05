# frozen_string_literal: true

class ChangeRequest < ActiveRecord::Base
  enum status: { pending: 0, approved: 1, rejected: 2 }
  enum action: { insert: 0, edit: 1, remove: 2 }

  has_many :field_changes, dependent: :destroy
  belongs_to :resource
end
