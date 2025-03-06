class RenameCategoryCovidPrefixToSfsg < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      select_all("SELECT id, name FROM categories WHERE name LIKE 'Covid-%'", "get Covid categories").each do |row|
        old = row["name"]
        new = row["name"].gsub("Covid-", "sfsg-")
        exec_query("UPDATE categories SET name = $1 WHERE name = $2", "rename #{old} to #{new}", [new, old])
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
