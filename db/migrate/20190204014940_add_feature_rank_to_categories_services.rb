class AddFeatureRankToCategoriesServices < ActiveRecord::Migration[5.0]
  def change
    add_column :categories_services, :feature_rank, :integer
  end
end
