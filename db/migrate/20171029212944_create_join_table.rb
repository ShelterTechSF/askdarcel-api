class CreateJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :services, :eligibilities do |t|
      # t.index [:service_id, :eligibility_id]
      # t.index [:eligibility_id, :service_id]
    end
  end
end
