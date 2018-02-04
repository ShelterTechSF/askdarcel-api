class AddResourceToVolunteers < ActiveRecord::Migration[5.0]
  def change
    add_reference :volunteers, :resource, foreign_key: true
  end
end
