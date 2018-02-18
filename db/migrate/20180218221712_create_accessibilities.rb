class CreateAccessibilities < ActiveRecord::Migration[5.0]
  def change
    create_table :accessibilities do |t|
      t.string :accessibility
      t.string :details

      t.timestamps
    end
  end
end
