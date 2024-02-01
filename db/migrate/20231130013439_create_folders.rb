class CreateFolders < ActiveRecord::Migration[6.1]
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :order
      t.references :user, foreign_key: true
      t.timestamps
    end
  end

end
