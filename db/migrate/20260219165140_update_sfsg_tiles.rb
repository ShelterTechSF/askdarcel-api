class UpdateSfsgTiles < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      @assertions_enabled = true

      ## sfsg-health
      create_category_relationship 'sfsg-health', 'Medical Care' 
      create_category_relationship 'sfsg-health', 'Mental Health Care' 
      create_category_relationship 'sfsg-health', 'Dental Care' 
      create_category_relationship 'sfsg-health', 'HIV Treatment' 
      create_category_relationship 'sfsg-health', 'STD/STI Treatment & Prevention' 
      create_category_relationship 'sfsg-health', 'Hospice' 
      create_category_relationship 'sfsg-health', 'In-Home Support' 
      create_category_relationship 'sfsg-health', 'Assisted Living' 
      create_category_relationship 'sfsg-health', 'Disease Screening' 

      delete_category_relationship 'sfsg-health', 'Coronavirus-Related Urgent Care' 
      delete_category_relationship 'sfsg-health', 'Coronavirus (COVID-19) Testing' 
         
      ## sfsg-shelter
      create_category 'Adult Shelter Reservation'

      create_category_relationship 'sfsg-shelter', 'Adult Shelter Reservation'
      create_category_relationship 'sfsg-shelter', 'Family Shelters'
      
      delete_category_relationship 'sfsg-shelter', 'We are a family with children under 18 years old.' 

      ## sfsg-lgbtqa
      create_category_relationship 'sfsg-lgbtqa', 'Medical Care' 
      create_category_relationship 'sfsg-lgbtqa', 'Dental Care' 
      create_category_relationship 'sfsg-lgbtqa', 'HIV Treatment' 
      create_category_relationship 'sfsg-lgbtqa', 'STD/STI Treatment & Prevention' 
      create_category_relationship 'sfsg-lgbtqa', 'Hospice' 
      create_category_relationship 'sfsg-lgbtqa', 'In-Home Support' 
      create_category_relationship 'sfsg-lgbtqa', 'Assisted Living' 
      create_category_relationship 'sfsg-lgbtqa', 'Disease Screening'
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_category(name)
    assert_category_does_not_exist name

    exec_query <<-SQL, "create category #{name}", [name]
      INSERT INTO categories (name, created_at, updated_at)
        VALUES ($1, now(), now())
        ON CONFLICT (name) DO NOTHING;
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
        VALUES ($1, $2)
        ON CONFLICT (parent_id, child_id) DO NOTHING;
    SQL
  end

  def delete_category_relationship(parent_name, child_name)
    assert_category_relationship_exists parent_name, child_name

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

    exec_query <<-SQL, "delete category relationship #{parent_name} -> #{child_name}", [parent_id, child_id]
      DELETE FROM category_relationships
      WHERE parent_id = $1 AND child_id = $2;
    SQL
  end

  def assert_category_relationship_exists(parent_name, child_name)
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
    raise "Expected relationship #{parent_name}->#{child_name} to exist, got #{count} results" unless count.to_i > 0
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
    raise "Expected relationship #{parent_name}->#{child_name} to not exist, got #{count} results" unless count == 0
  end

  def assert_category_does_not_exist(name)
    return unless @assertions_enabled

    count = select_value("SELECT COUNT(*) FROM categories WHERE name = $1", "count category #{name}", [name])
    raise "Expected category #{name} to not exist, got #{count} results" unless count == 0
  end
end
