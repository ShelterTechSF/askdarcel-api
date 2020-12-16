class TextingRecipient < ApplicationRecord
  has_many :textings, dependent: :destroy
  validates :phone_number, presence: true
end
