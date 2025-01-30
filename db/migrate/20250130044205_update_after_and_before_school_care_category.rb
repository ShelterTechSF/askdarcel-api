class UpdateAfterAndBeforeSchoolCareCategory < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      # Set this to true to enable assertions
      @assertions_enabled = true

      rename_category from: 'After & Before School Care', to: 'After & Before School'

      create_subcategory_relationship('Arts, Culture & Identity', 'After & Before School')
      create_subcategory_relationship("Education", 'After & Before School')
      create_subcategory_relationship("Sports & Recreation", 'After & Before School')
      create_subcategory_relationship("Youth Workforce & Life Skills", 'After & Before School')
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def rename_category(from:, to:)
    assert_category_exists from
    assert_category_does_not_exist to

    exec_query <<-SQL, "rename category from #{from} to #{to}", [to, from]
      UPDATE categories
        SET name = $1
        WHERE name = $2;
    SQL
  end

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

  def category_id(name)
    id = select_value("SELECT id FROM categories WHERE name = $1", "get category id #{name}", [name])
    raise "Category #{name} does not exist" if id.nil?
    id
  end

  def create_subcategory_relationship(top_category, subcategory)
    top_category_id = category_id(top_category)
    subcategory_id = category_id(subcategory)
    exec_query <<-SQL, "create subcategory relationship #{top_category} -> #{subcategory}", [top_category_id, subcategory_id]
      INSERT INTO category_relationships (parent_id, child_id)
        VALUES ($1, $2);
    SQL
  end
end
