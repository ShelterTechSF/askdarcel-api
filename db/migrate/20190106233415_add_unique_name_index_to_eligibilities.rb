class AddUniqueNameIndexToEligibilities < ActiveRecord::Migration[5.0]
  def change
    add_index :eligibilities, :name, unique: true
  end
end
