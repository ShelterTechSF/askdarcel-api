class AddServiceToContacts < ActiveRecord::Migration[5.0]
  def change
    add_reference :contacts, :service, foreign_key: true
  end
end
