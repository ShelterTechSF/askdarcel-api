class AddStatusToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :status, :integer
    Service.all.each { |s| s.update_attribute :status, :approved }
  end
end
