class AddDcyfTopLevelCategories < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      # Set this to true to enable assertions
      @assertions_enabled = true

      rename_category from: 'Mentoring', to: 'Mentorship'

      MAPPING.each do |top_category, categories|
        create_top_level_category(top_category)

        categories.each do |category|
          create_subcategory_relationship(top_category, category)
        end
      end
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

  def create_top_level_category(name)
    exec_query <<-SQL, "create top-level category #{name}", [name]
      INSERT INTO categories (name, top_level, created_at, updated_at)
        VALUES ($1, true, now(), now());
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
    "Arts, Culture & Identity" => [
      "Arts and Creative Expression",
      "Culinary Arts",
      "Culture & Identity",
      "Team Sports",
      "Digital Media Production",
      "Disability Support",
      "Justice Involvement",
      "LGBTQ+ Support",
      "Summer Programs",
    ],
    "Children's Care" => [
      "After & Before School Care",
      "Childcare",
      "Playgroups",
      "Summer Programs",
    ],
    "Education" => [
      "Academic Support",
      "Alternative Education & GED",
      "College Prep",
      "Computer Class",
      "Disability Support",
      "Financial Education",
      "Foreign Languages",
      "Free City College",
      "Justice Involvement",
      "Learning English",
      "LGBTQ+ Support",
      "Public Schools",
      "Reading & Literacy",
      "SEL (Social Emotional Learning)",
      "Special Education",
      "STEM",
      "Summer Programs",
    ],
    "Family Support" => [
      "Child Welfare Services",
      "Computer or Internet Access",
      "Disability Support",
      "Legal Services",
      "Family Resource Centers",
      "Family Shelters",
      "Emergency Financial Assistance",
      "Food",
      "Foster Care Services",
      "Housing & Rental Assistance",
      "Immigration Assistance",
      "Justice Involvement",
      "LGBTQ+ Support",
      "Parent Education",
      "Support Groups",
      "Teen Parents",
    ],
    "Health & Wellness" => [
      "Addiction & Recovery",
      "Crisis Intervention",
      "Dental Care",
      "Disability Support",
      "Health Education",
      "Justice Involvement",
      "LGBTQ+ Support",
      "Medical Care",
      "Mental Health Care",
      "Vision Care",
    ],
    "Sports & Recreation" => [
      "Disability Support",
      "Gardening",
      "Justice Involvement",
      "LGBTQ+ Support",
      "Outdoors",
      "Summer Programs",
      "Physical Fitness",
      "Team Sports",
    ],
    "Youth Workforce & Life Skills" => [
      "Apprenticeship",
      "Career Exploration",
      "Disability Support",
      "Job Assistance",
      "Justice Involvement",
      "LGBTQ+ Support",
      "Mentorship",
      "Skills & Training",
      "Summer Programs",
      "Vocational Training",
      "Youth Jobs & Internships",
      "Youth Leadership",
    ]
  }
end
