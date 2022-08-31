class CreateTableServiceDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table "service_documents", :id => false do |t|
      t.integer :service_id
      t.integer :document_id
    end
  end
end
