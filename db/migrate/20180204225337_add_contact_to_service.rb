class AddContactToService < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :service, foreign_key: true
  end
end
