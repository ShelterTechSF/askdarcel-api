class CreateTableDocumentsServices < ActiveRecord::Migration[6.1]
    def change
      create_table :documents_services, :id => false do |t|
        t.integer :service_id
        t.integer :document_id
      end
    end
  end