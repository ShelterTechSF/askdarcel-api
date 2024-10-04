class AddNewDcyfCategories < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      # Set this to true to enable assertions
      @assertions_enabled = true

      MAPPING.each do |top_category, categories|
        assert_category_exists(top_category)

        categories.each do |category|
          create_category(category)
          create_subcategory_relationship(top_category, category)
        end
      end

      # Unlike all the other subcategories, this one already exists, but we just
      # want to link it to another top-level category.
      assert_category_exists("Playgroups")
      assert_category_exists("Sports & Recreation")
      create_subcategory_relationship("Sports & Recreation", "Playgroups")
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

  def create_category(name)
    assert_category_does_not_exist name

    exec_query <<-SQL, "create category #{name}", [name]
      INSERT INTO categories (name, created_at, updated_at)
        VALUES ($1, now(), now())
        ON CONFLICT (name) DO NOTHING;
    SQL
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


  MAPPING = {
    "Education" => [
      "Truancy Prevention",
    ],
    "Sports & Recreation" => [
      "Board Games",
      "Circus Arts",
      "Cycling",
      "Meditation",
      "Pilates",
      "Rock Climbing",
      "Ropes Course",
      "Sports Programs",
      "Zumba",
    ],
  }
end
