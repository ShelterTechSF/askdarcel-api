class TextingRecipient < ApplicationRecord
  has_many :textings, dependent: :destroy
end
