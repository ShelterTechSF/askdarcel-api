class AddServiceAtLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :service_at_locations do |t|
    	t.belongs_to :service
    	t.belongs_to :address
    	t.belongs_to :schedule
    end
  end
end
