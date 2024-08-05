class AddBoostedCategoryToServices < ActiveRecord::Migration[6.1]
  def change
    add_reference :services, :boosted_category, foreign_key: { to_table: :categories }
  end
end
