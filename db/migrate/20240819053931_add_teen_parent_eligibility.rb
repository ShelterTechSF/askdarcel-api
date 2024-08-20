class AddTeenParentEligibility < ActiveRecord::Migration[6.1]
  def up
    exec_query <<-SQL, "create tean parent eligibility", ["Teen Parent"]
      INSERT INTO eligibilities (name, created_at, updated_at)
        VALUES ($1, now(), now())
        ON CONFLICT (name) DO NOTHING;
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
