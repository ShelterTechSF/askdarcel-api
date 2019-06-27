class AddSourceAttributionToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :source_attribution, :integer, default: 0
  end
end
