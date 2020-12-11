class Texting < ApplicationRecord
  belongs_to :texting_recipient
  belongs_to :service
end
