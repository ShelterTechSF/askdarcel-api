class DropRatings < ActiveRecord::Migration[5.2]
  def change
    if table_exists?(:ratings)
      drop_table :ratings
    end
  end
end
