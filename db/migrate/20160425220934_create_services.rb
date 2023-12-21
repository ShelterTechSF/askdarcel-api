class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.timestamps null: false

      t.string :name
      t.text :long_description
      t.string :eligibility
      t.string :required_documents
      t.decimal :fee
      t.text :application_process
      t.references :resource, index: true, foreign_key: true
    end
  end
end
