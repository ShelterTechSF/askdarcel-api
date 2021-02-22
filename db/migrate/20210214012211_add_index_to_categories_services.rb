class AddIndexToCategoriesServices < ActiveRecord::Migration[5.2]
  def change
    add_index :categories_services, :category_id
    add_index :categories_services, :service_id
  end
end
