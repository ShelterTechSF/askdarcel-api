class UpdateSfsgFinanceAndJobsCategories < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      @assertions_enabled = true

      rename_category(
        from: 'Financial assistance for living expenses',
        to: 'Financial Assistance'
      )

      create_category_relationship 'sfsg-finance', 'Legal Services'
      create_category_relationship 'sfsg-finance', 'Tax Preparation'
      create_category_relationship 'sfsg-jobs', 'Alternative Education & GED'
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def assert_category_exists(name)
    return unless @assertions_enabled

    count = select_value("SELECT COUNT(*) FROM categories WHERE name = $1", "count category #{name}", [name])
    raise "Expected category #{name} to exist, got #{count} results" unless count == 1
  end

  def assert_category_does_not_exist(name)
    return unless @assertions_enabled

    count = select_value("SELECT COUNT(*) FROM categories WHERE name = $1", "count category #{name}", [name])
    raise "Expected category #{name} to not exist, got #{count} results" unless count == 0
  end

  def rename_category(from:, to:)
    assert_category_exists from
    assert_category_does_not_exist to

    exec_query <<-SQL, "rename category from #{from} to #{to}", [to, from]
      UPDATE categories
        SET name = $1
        WHERE name = $2;
    SQL
  end

  def create_category_relationship(parent_name, child_name)
    parent_id = select_value(
      "SELECT id FROM categories WHERE name = $1",
      "find parent #{parent_name}",
      [parent_name]
    )

    child_id = select_value(
      "SELECT id FROM categories WHERE name = $1",
      "find child #{child_name}",
      [child_name]
    )

    assert_category_relationship_does_not_exist parent_name, child_name

    exec_query <<-SQL, "create category relationship #{parent_name} -> #{child_name}", [parent_id, child_id]
      INSERT INTO category_relationships (parent_id, child_id)
        VALUES ($1, $2);
    SQL
  end

  def assert_category_relationship_does_not_exist(parent_name, child_name)
    return unless @assertions_enabled

    parent_id = select_value(
      "SELECT id FROM categories WHERE name = $1",
      "find parent #{parent_name}",
      [parent_name]
    )

    child_id = select_value(
      "SELECT id FROM categories WHERE name = $1",
      "find child #{child_name}",
      [child_name]
    )

    raise "Expected parent category #{parent_name} to exist" if parent_id.nil?
    raise "Expected child category #{child_name} to exist" if child_id.nil?

    count = select_value(
      "SELECT COUNT(*) FROM category_relationships WHERE parent_id = $1 AND child_id = $2",
      "count relationship #{parent_name}->#{child_name}",
      [parent_id, child_id]
    )
    raise "Expected relationship #{parent_name}->#{child_name} to not exist, got #{count} results" unless count.to_i == 0
  end
end