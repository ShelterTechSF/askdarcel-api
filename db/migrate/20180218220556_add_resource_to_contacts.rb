class AddResourceToContacts < ActiveRecord::Migration[5.0]
  def change
    add_reference :contacts, :resource, foreign_key: true
  end
end
