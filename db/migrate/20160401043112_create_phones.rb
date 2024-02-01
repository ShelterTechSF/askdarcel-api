class CreatePhones < ActiveRecord::Migration[6.1]
  def change
    create_table :phones do |t|
      t.timestamps null: false

      t.string :number, null: false
      t.string :extension
      t.string :type, null: false
      t.string :country_code, null: false
      t.references :resource, index: true, foreign_key: true, null: false
    end
  end
end
