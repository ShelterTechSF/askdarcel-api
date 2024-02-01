class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.timestamps null: false

      t.string :attention
      t.string :address_1, null: false
      t.string :address_2
      t.string :address_3
      t.string :address_4
      t.string :city, null: false
      t.string :state_province, null: false
      t.string :postal_code, null: false
      t.string :country, null: false
      t.references :resource, index: true, foreign_key: true, null: false
    end
  end
end
