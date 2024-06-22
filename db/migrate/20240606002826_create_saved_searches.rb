class CreateSavedSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_searches do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.jsonb :search, null: false, default: '{}'
      t.timestamps
    end
  end
end
