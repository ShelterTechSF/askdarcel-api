class UpdateDcyfCategoriesAndEligibilties < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.transaction do
      # Set this to true to enable assertions
      @assertions_enabled = true

      ## Categories

      # Arts and Creative Expression
      ['Creative Writing', 'Music', 'Performing Arts', 'Photography and Film', 'Spoken Word', 'Theater', 'Visual Arts'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'Arts and Creative Expression'
        delete_category from
      end

      # Digital Media Production
      rename_category from: 'Digital Arts', to: 'Digital Media Production'

      # Disability Support
      rename_category from: 'Disability', to: 'Disability Support'

      # Justice Involvement
      create_category 'Justice Involvement'

      # LGBTQ+ Support
      rename_category from: 'LGBTQ', to: 'LGBTQ+ Support'

      # After & Before School Care
      create_category 'After & Before School Care'

      ['After School Care', 'Afterschool Programs', 'Before School Care'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'After & Before School Care'
        delete_category from
      end

      # Playgroups
      create_category 'Playgroups'

      # Academic Support
      create_category 'Academic Support'

      # TODO: Need to get the answer to two issues:
      # 1) Summer School is not an actual category name
      # 2) The spreadsheet says to _not_ delete Summer School, unlike all the
      # others
      # ['Academic', 'Education', 'Educational Supports', 'Tutoring', 'School Care', 'Summer School'].each do |from|
      #   migrate_resources_and_services_to_new_category from: from, to: 'Academic Support'
      #   delete_category from
      # end

      # Alternative Education & GED
      create_category 'Alternative Education & GED'

      ['Alternative Education', 'GED/High School Equivalency', 'GED/High-School Equivalency'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'Alternative Education & GED'
        delete_category from
      end

      # Free City College
      create_category 'Free City College'

      # Learning English
      rename_category from: 'Language', to: 'Learning English'

      # Public Schools
      create_category 'Public Schools'

      # Reading & Literacy
      rename_category from: 'Literacy Supports', to: 'Reading & Literacy'

      # Child Welfare Services
      create_category 'Child Welfare Services'

      # Foster Care Services
      rename_category from: 'Foster Care', to: 'Foster Care Services'

      # Housing & Rental Assistance
      rename_category from: 'Housing', to: 'Housing & Rental Assistance'

      ['Housing Assistance', 'Emergency Rental Assistance'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'Housing & Rental Assistance'
      end

      # Immigration Assistance
      create_category 'Immigration Assistance'

      migrate_resources_and_services_to_new_category from: 'Citizenship & Immigration', to: 'Immigration Assistance'

      # Teen Parents
      create_category 'Teen Parents'

      # Crisis Intervention
      create_category 'Crisis Intervention'

      ['Suicide', 'Sexual Assault Hotlines', 'Hotlines and Case Management', 'Help Hotlines', 'Domestic Violence Hotlines'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'Crisis Intervention'
      end

      # Gardening
      rename_category from: 'Nature & Gardening', to: 'Gardening'

      # Physical Fitness
      create_category 'Physical Fitness'

      ['Fitness & Exercise', 'Fitness/Exercise'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'Physical Fitness'
        delete_category from
      end

      # Team Sports
      create_category 'Team Sports'

      ['Basketball', 'Cheer', 'Dance', 'Football', 'Rec Teams', 'Soccer', 'Sports', 'Surfing', 'Swimming', 'Ultimate Frisbee'].each do |from|
        migrate_resources_and_services_to_new_category from: from, to: 'Team Sports'
        delete_category from
      end

      # Apprenticeship
      create_category 'Apprenticeship'

      # Career Exploration
      rename_category from: 'Career Awareness', to: 'Career Exploration'

      # Youth Jobs & Internships
      rename_category from: 'Internships', to: 'Youth Jobs & Internships'


      ## Eligibilities

      # Hispanic/Latinx
      rename_eligibility from: 'Latinx', to: 'Hispanic/Latinx'

      # Middle School
      rename_eligibility from: 'Middle School Students', to: 'Middle School'

      # High School
      rename_eligibility from: 'High School Students', to: 'High School'

      # College
      rename_eligibility from: 'College Students', to: 'College'

      # CSF
      create_eligibility 'CCSF'

      # Experiencing Homelessness
      rename_eligibility from: 'I am someone experiencing homelessness', to: 'Experiencing Homelessness'

      # Boys
      create_eligibility 'Boys'

      # Girls
      create_eligibility 'Girls'
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

  def create_category(name)
    assert_category_does_not_exist name

    exec_query <<-SQL, "create category #{name}", [name]
      INSERT INTO categories (name, created_at, updated_at)
        VALUES ($1, now(), now())
        ON CONFLICT (name) DO NOTHING;
    SQL
  end

  # Note: This does not create the new category or delete the old ones, since
  # for some migrations, we already have the new category, and for some
  # migrations, we should preserve the existing categories.
  def migrate_resources_and_services_to_new_category(from:, to:)
    assert_category_exists from
    assert_category_exists to

    exec_query <<-SQL, "migrate resources from #{from} to #{to}", [to, from]
      INSERT INTO categories_resources
      SELECT DISTINCT resources.id as resource_id, (SELECT categories.id FROM categories WHERE categories.name = $1 LIMIT 1) as category_id
        FROM resources
          INNER JOIN categories_resources ON categories_resources.resource_id = resources.id
          INNER JOIN categories ON categories_resources.category_id = categories.id
        WHERE categories.name = $2
          -- Avoid inserting duplicate rows by excluding resources already associated with this category
          AND resource_id NOT IN (
            SELECT categories_resources.resource_id
              FROM categories_resources
                INNER JOIN categories ON categories_resources.category_id = categories.id
              WHERE categories.name = $1
          );
    SQL

    exec_query <<-SQL, "migrate services from #{from} to #{to}", [to, from]
      INSERT INTO categories_services
      SELECT DISTINCT services.id as service_id, (SELECT categories.id FROM categories WHERE categories.name = $1 LIMIT 1) as category_id
        FROM services
          INNER JOIN categories_services ON categories_services.service_id = services.id
          INNER JOIN categories ON categories_services.category_id = categories.id
        WHERE categories.name = $2
          -- Avoid inserting duplicate rows by excluding services already associated with this category
          AND service_id NOT IN (
            SELECT categories_services.service_id
              FROM categories_services
                INNER JOIN categories ON categories_services.category_id = categories.id
              WHERE categories.name = $1
          );
    SQL
  end

  def delete_category(name)
    assert_category_exists name

    # categories_sites doesn't have a cascade delete for categories, so we have to manually delete from it
    exec_query <<-SQL, "delete category_sites category #{name}", [name]
      DELETE FROM categories_sites
        WHERE category_id IN (SELECT id FROM categories WHERE name = $1);
    SQL

    exec_query <<-SQL, "delete category #{name}", [name]
      DELETE FROM categories
        WHERE name = $1;
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

  def create_eligibility(name)
    assert_eligibility_does_not_exist name

    exec_query <<-SQL, "create eligibility #{name}", [name]
      INSERT INTO eligibilities (name, created_at, updated_at)
        VALUES ($1, now(), now())
        ON CONFLICT (name) DO NOTHING;
    SQL
  end

  def rename_eligibility(from:, to:)
    assert_eligibility_exists from
    assert_eligibility_does_not_exist to

    exec_query <<-SQL, "rename eligibility from #{from} to #{to}", [to, from]
      UPDATE eligibilities
        SET name = $1
        WHERE name = $2;
    SQL
  end

  def assert_eligibility_exists(name)
    return unless @assertions_enabled

    count = select_value("SELECT COUNT(*) FROM eligibilities WHERE name = $1", "count eligibility #{name}", [name])
    raise "Expected eligibility #{name} to exist, got #{count} results" unless count == 1
  end

  def assert_eligibility_does_not_exist(name)
    return unless @assertions_enabled

    count = select_value("SELECT COUNT(*) FROM eligibilities WHERE name = $1", "count eligibility #{name}", [name])
    raise "Expected eligibility #{name} to not exist, got #{count} results" unless count == 0
  end
end
