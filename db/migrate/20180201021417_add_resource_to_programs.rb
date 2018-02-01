class AddResourceToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_reference :programs, :resource, foreign_key: true
  end
end
