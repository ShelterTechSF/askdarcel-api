class AddIsParentToEligibilities < ActiveRecord::Migration[6.1]
  def change
    add_column :eligibilities, :is_parent, :boolean, :default => false
  end
end
