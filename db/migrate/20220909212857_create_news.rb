class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.integer :id, :null => false
      t.string :headline, :null => false
      t.datetime :effective_date, :null => false
      t.string :body, :null => false
      t.integer :priority, :null => false
      t.datetime :expiration_date, :null => false
    end
  end
end

