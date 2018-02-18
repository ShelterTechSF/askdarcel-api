class AddContactToPhones < ActiveRecord::Migration[5.0]
  def change
    add_reference :phones, :contact, foreign_key: true
  end
end
