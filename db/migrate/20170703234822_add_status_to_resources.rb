class AddStatusToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :status, :integer, :default => :pending
    Resource.all.each { |r| r.update_attribute :status, :approved }
  end
end
