class AddContactToService < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :contact, foreign_key: true
  end
end
