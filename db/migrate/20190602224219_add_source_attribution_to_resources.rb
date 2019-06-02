class AddSourceAttributionToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :source_attribution, :integer, default: 0
  end
end
