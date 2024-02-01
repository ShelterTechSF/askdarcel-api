class DropReviews < ActiveRecord::Migration[6.1]
  def change
    if table_exists?(:reviews)
      drop_table :reviews
    end  
  end
end
