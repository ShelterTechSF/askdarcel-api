# frozen_string_literal: true

class Texting < ApplicationRecord
  belongs_to :texting_recipient
  belongs_to :service
  belongs_to :resource
end
