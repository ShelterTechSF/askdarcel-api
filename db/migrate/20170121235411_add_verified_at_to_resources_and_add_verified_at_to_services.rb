class AddVerifiedAtToResourcesAndAddVerifiedAtToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :verified_at, :datetime
    add_column :services, :verified_at, :datetime
  end
end
