class AddFeatureRankToEligibilities < ActiveRecord::Migration[5.0]
  def change
    add_column :eligibilities, :feature_rank, :integer

    # to return eligibilities sorted by feature_rank
    add_index :eligibilities, :feature_rank

    # for efficient lookup in join table
    add_index :eligibilities_services, :eligibility_id
    add_index :eligibilities_services, :service_id
  end
end
