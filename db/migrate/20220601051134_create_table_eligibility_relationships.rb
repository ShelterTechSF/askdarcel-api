class CreateTableEligibilityRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table "eligibility_relationships", :id => false do |t|
      t.integer :parent_id, :null => false
      t.integer :child_id, :null => false
    end
  end
end
