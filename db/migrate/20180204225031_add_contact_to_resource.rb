class AddContactToResource < ActiveRecord::Migration[5.0]
  def change
    add_reference :resources, :contact, foreign_key: true
  end
end
