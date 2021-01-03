# frozen_string_literal: true

require 'faker/sheltertech'

module ShelterTech
  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/MethodLength

  module DB
    class FixturePopulator
      def self.populate
        populator = new
        if Rails.configuration.x.algolia.enabled
          algolia_deferred_index_update { populator.populate }
        else
          populator.populate
        end
      end

      # Temporarily disable Algolia indexes so that we can do it once in bulk.
      def self.algolia_deferred_index_update
        Resource.without_auto_index do
          Service.without_auto_index do
            yield
          end
        end
        Resource.reindex!
        Service.reindex!
      end

      def populate
        Rails.application.eager_load! # Load all models
        create_categories
        create_resources
        create_eligibilities
        create_sites
        NewPathwaysCategoryCreator.create_all_new_pathway_categories
      end

      def reset_db
        ActiveRecord::Base.transaction do
          ActiveRecord::Base.descendants.each do |model|
            next if model.to_s == 'ApplicationRecord'
            next if model.to_s.starts_with? 'ActiveRecord::'

            model.destroy_all
            ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
          end
        end
      end

      def categories
        @categories ||= Category.all
      end

      def top_level_categories
        @top_level_categories ||= Category.where(top_level: true)
      end

      def featured_categories
        @featured_categories ||= Category.where(featured: true)
      end

      def create_categories
        Constants::CATEGORY_NAMES.each { |name| FactoryBot.create(:category, name: name) }
        Constants::TOP_LEVEL_CATEGORY_NAMES.each do |c|
          Category.find_by_name!(c).update(top_level: true)
        end
        Constants::FEATURED_CATEGORY_NAMES.each do |c|
          Category.find_by_name!(c).update(featured: true)
        end

        create_category_children
      end

      def create_category_children
        parent = Category.find_by_name('Legal')
        Constants::CHILD_CATEGORY_NAMES.each do |c|
          child = Category.find_by_name(c)
          relationship = CategoryRelationship.new
          relationship.parent = parent
          relationship.child = child
          relationship.save
        end
      end

      def create_resources
        resource_creator = ResourceCreator.new(categories: categories, top_level_categories: top_level_categories)
        128.times { resource_creator.create_random_resource }

        featured_categories.each do |featured_category|
          4.times.each do
            resource_creator.create_random_resource(categories: [featured_category])
          end
          update_services_feature_rank(featured_category)
        end

        TestCafeResourceCreator.create
      end

      # For featured categories, set `feature_rank` for some
      # `categories_services` relationships.
      def update_services_feature_rank(featured_category)
        categories_services = CategoriesService.where(category_id: featured_category.id).limit(2)
        categories_services.limit(2).each_with_index do |categories_service, i|
          # the `categories_services` table does not have an `id` column, so we
          # can't use the standard `update` method. We need to query using the
          # table's unique key `[category_id, service_id]` and use the
          # `update_all` method.
          CategoriesService.where(
            category_id: categories_service.category_id,
            service_id: categories_service.service_id
          ).update_all(feature_rank: i + 1)
        end
      end

      def create_eligibilities
        EligibilityCreator.create
      end

      def create_sites
        sfsg = Site.new
        sfsg.site_code = "sfsg"
        sfsg.save!

        sff = Site.new
        sff.site_code = "sffamilies"
        sff.save!
      end
    end

    class NewPathwaysCategoryCreator
      def self.create_all_new_pathway_categories
        create_new_pathway_categories('Covid-food', 1_000_001, ['Disabled', 'Seniors (55+ years old)', 'Families', 'Homeless'])
        create_new_pathway_categories_by_subcategory('Covid-hygiene', 1_000_002,
                                                     ['Portable Toilets and Hand-Washing Stations',
                                                      'Hygiene kits', 'Showers', 'Laundry', 'Clothing', 'Diaper Bank'])
        create_new_pathway_categories_by_subcategory('Covid-finance', 1_000_003, ['Emergency Financial Assistance',
                                                                                  'Financial Assistance for Living Expenses',
                                                                                  'Unemployment Insurance-based Benefit Payments', 'Job Assistance'])
        create_new_pathway_categories_by_subcategory('Covid-housing', 1_000_004, ['My landlord gave me an eviction notice and I need legal help',
                                                                                  'My landlord told me I would get evicted and I need advice',
                                                                                  'I have not been able to pay my rent and I do not know what to do',
                                                                                  'I am not getting along with my neighbor(s) and /or my landlord and I need advice'])
        create_new_pathway_categories_by_subcategory('Covid-health', 1_000_005, ['Coronavirus (COVID-19) Testing', 'Coronavirus-Related Urgent Care',
                                                                                 'Other Medical Services', 'Mental Health Urgent Care', 'Other Mental Health Services'])
        create_new_pathway_categories_by_subcategory('Covid-domesticviolence', 1_000_006, ['Temporary Shelter for Women',
                                                                                           'Transitional Housing for Women',
                                                                                           'Legal Assistance', 'Domestic Violence Counseling'])
        create_new_pathway_categories_by_subcategory('Covid-internet', 1_000_007, ['Computer and Internet Access', 'Computer Classes', 'Cell phone Services'])
        create_new_pathway_categories_by_subcategory('Covid-lgbtqa', 1_000_008, ['Housing Assistance', 'Legal Assistance ',
                                                                                 'Youth Services', 'Counseling Assistance', 'General Help'])
        create_new_pathway_categories_by_subcategory('Covid-shelter', 1_000_010, ['We are a family and we need shelter',
                                                                                  'I am someone between 18-24 years old in need of shelter',
                                                                                  'I am a single adult and I need shelter'])
      end

      def self.create_new_pathway_categories(name, id, eligibilities)
        category = Category.new
        category.name = name
        category.id = id
        category.save!

        add_eligibilities(eligibilities, category)
      end

      def self.create_new_pathway_categories_by_subcategory(name, id, subcategories)
        category = Category.new
        category.name = name
        category.id = id
        category.save!

        add_subcategories(subcategories, category)
      end

      def self.add_eligibilities(eligibilities, category)
        eligibilities.each do |eligibility_name|
          eligibility = Eligibility.find_by_name(eligibility_name)
          resource = FactoryBot.create(:resource, name: Faker::Company.name,
                                                  short_description: Faker::Lorem.sentence,
                                                  long_description: Faker::ShelterTech.description,
                                                  website: Faker::Internet.url, categories: [category])
          service = FactoryBot.create(:service, resource: resource,
                                                long_description: Faker::ShelterTech.description, categories: [category])
          eligibility.services << service
        end
      end

      def self.add_subcategories(subcategories, category) # rubocop:disable Metrics/MethodLength
        subcategories.each do |subcategory_name|
          subcategory = Category.new
          subcategory.name = subcategory_name
          subcategory.save!
          resource = FactoryBot.create(:resource, name: Faker::Company.name,
                                                  short_description: Faker::Lorem.sentence,
                                                  long_description: Faker::ShelterTech.description,
                                                  website: Faker::Internet.url, categories: [subcategory])
          service = FactoryBot.create(:service, resource: resource,
                                                long_description: Faker::ShelterTech.description, categories: [subcategory])
          category.categories << subcategory
          category.services << service
        end
      end
    end

    class ResourceCreator
      def initialize(categories:, top_level_categories:)
        @top_level_categories = top_level_categories
        @categories = categories
      end

      def create_random_resource(categories: nil)
        categories ||= @top_level_categories.sample(rand(2)) + @categories.sample(rand(2))
        resource = FactoryBot.create(:resource,
                                     name: Faker::Company.name,
                                     short_description: random_short_description,
                                     long_description: Faker::ShelterTech.description,
                                     website: random_website,
                                     categories: categories)

        resource.services = create_random_services(resource, categories)
      end

      def random_short_description
        rand(2).zero? ? '' : Faker::Lorem.sentence
      end

      def random_website
        rand(2).zero? ? '' : Faker::Internet.url
      end

      def create_random_service(resource, categories)
        service = FactoryBot.create(:service,
                                    resource: resource,
                                    long_description: Faker::ShelterTech.description,
                                    categories: categories)

        FactoryBot.create(:change_request,
                          type: 'ResourceChangeRequest',
                          status: ChangeRequest.statuses[:pending],
                          object_id: resource.id)
        service
      end

      def create_random_services(resource, categories)
        Array.new(rand(1..2)) { create_random_service(resource, categories) }
      end
    end

    module TestCafeResourceCreator
      def self.create
        test_category = create_test_category
        resource = create_resource(test_category)
        resource.services = [create_service(resource, test_category)]
        create_change_request(resource)
      end

      def self.create_test_category
        # The TestCafe tests expect ID 234 to have these properties.
        FactoryBot.create(:category, name: 'Test_Category_Top_Level', id: 234, top_level: true)
      end

      def self.create_resource(test_category)
        FactoryBot.create(:resource,
                          name: "A Test Resource",
                          short_description: "I am a short description of a resource.",
                          long_description: "I am a long description of a resource.",
                          website: "www.fakewebsite.org",
                          categories: [test_category])
      end

      def self.create_service(resource, test_category)
        FactoryBot.create(:service,
                          name: "A Test Service",
                          resource: resource,
                          long_description: "I am a long description of a service.",
                          categories: [test_category])
      end

      def self.create_change_request(resource)
        FactoryBot.create(:change_request,
                          type: 'ResourceChangeRequest',
                          status: ChangeRequest.statuses[:pending],
                          object_id: resource.id)
      end
    end

    # Performs the following writes:
    # - Create one eligibility for each of the names in ELIGIBILITY_NAMES
    # - If an eligibility should be featured, update its feature_rank according to
    #   the values in ELIGIBILITY_RESOURCE_COUNTS.
    # - Associate each eligibility with some random resources. The number of
    #   resources to associate with an eligibility is defined in
    #   ELIGIBLITY_RESOURCE_COUNTS. Defaults to 5.
    module EligibilityCreator
      def self.create
        Constants::ELIGIBILITY_NAMES.map do |name|
          feature_rank = Constants::ELIGIBILITY_FEATURE_RANKS[name]
          resource_count = Constants::ELIGIBILITY_RESOURCE_COUNTS[name] || 5
          eligibility = FactoryBot.create(:eligibility, name: name, feature_rank: feature_rank)
          associate_with_random_resources(eligibility, resource_count)
        end
      end

      def self.associate_with_random_resources(eligibility, resource_count)
        resources = Resource.all.sample(resource_count)
        resources.each do |resource|
          eligibility.services << resource.services.sample
        end
      end
    end

    module Constants # rubocop:disable Metrics/ModuleLength
      CATEGORY_NAMES = [
        'Emergency',
        'Immediate Safety',
        'Help Escape Violence',
        'Psychiatric Emergency Services',
        'Food',
        'Food Delivery',
        'Food Pantry',
        'Free Meals',
        'Food Benefits',
        'Help Pay for Food',
        'Housing',
        'Temporary Shelter',
        'Help Pay For Housing',
        'Help Pay for Housing',
        'Help Pay for Utilities',
        'Help Pay for Internet or Phone',
        'Home & Renters Insurance',
        'Housing Vouchers',
        'Long-Term Housing',
        'Assisted Living',
        'Independent Living',
        'Nursing Home',
        'Public Housing',
        'Safe Housing',
        'Short-Term Housing',
        'Sober Living',
        'Goods',
        'Clothes for School',
        'Clothes for Work',
        'Clothing Vouchers',
        'Home Goods',
        'Medical Supplies',
        'Personal Safety',
        'Transit',
        'Bus Passes',
        'Help Pay for Transit',
        'Health',
        'Addiction & Recovery',
        'Dental Care',
        'Health Education',
        'Daily Life Skills',
        'Disease Management',
        'Family Planning',
        'Nutrition Education',
        'Parenting Education',
        'Sex Education',
        'Understand Disability',
        'Understand Mental Health',
        'Help Pay for Healthcare',
        'Disability Benefits',
        'Discounted Healthcare',
        'Health Insurance',
        'Prescription Assistance',
        'Transportation for Healthcare',
        'Medical Care',
        'Primary Care',
        'Birth Control',
        'Checkup & Test',
        'Disability Screening',
        'Disease Screening',
        'Hearing Tests',
        'Mental Health Evaluation',
        'Pregnancy Tests',
        'Fertility',
        'Maternity Care',
        'Personal Hygiene',
        'Postnatal Care',
        'Prevent & Treat',
        'Counseling',
        'HIV Treatment',
        'Pain Management',
        'Physical Therapy',
        'Specialized Therapy',
        'Vaccinations',
        'Mental Health Care',
        'Anger Management',
        'Bereavement',
        'Group Therapy',
        'Substance Abuse Counseling',
        'Family Counseling',
        'Individual Counseling',
        'Medicatons for Mental Health',
        'Drug Testing',
        'Hospice',
        'Vision Care',
        'Money',
        'Government Benefits',
        'Retirement Benefits',
        'Understand Government Programs',
        'Unemployment Benefits',
        'Financial Education',
        'Insurance',
        'Tax Preparation',
        'Care',
        'Daytime Care',
        'Adult Daycare',
        'After School Care',
        'Before School Care',
        'Childcare',
        'Help Find Childcare',
        'Help Pay for Childcare',
        'Day Camp',
        'Preschool',
        'Recreation',
        'Relief for Caregivers',
        'End-of-Life Care',
        'Navigating the System',
        'Help Fill out Forms',
        'Help Find Housing',
        'Help Find School',
        'Help Find Work',
        'Support Network',
        'Help Hotlines',
        'Home Visiting',
        'In-Home Support',
        'Mentoring',
        'One-on-One Support',
        'Peer Support',
        'Spiritual Support',
        'Support Groups',
        '12-Step',
        'Virtual Support',
        'Education',
        'Help Pay for School',
        'Books',
        'Financial Aid & Loans',
        'Transportation for School',
        'Supplies for School',
        'More Education',
        'Alternative Education',
        'English as a Second Language (ESL)',
        'Foreign Languages',
        'GED/High-School Equivalency',
        'Supported Employment',
        'Special Education',
        'Tutoring',
        'Screening & Exams',
        'Citizenship & Immigration',
        'Skills & Training',
        'Basic Literacy',
        'Computer Class',
        'Interview Training',
        'Resume Development',
        'Skills Assessment',
        'Specialized Training',
        'Work',
        'Job Placement',
        'Help Pay for Work Expenses',
        'Workplace Rights',
        'Legal',
        'Advocacy & Legal Aid',
        'Discrimination & Civil Rights',
        'Guardianship',
        'Identification Recovery',
        'Mediation',
        'Notary',
        'Representation',
        'Translation & Interpretation',
        'Homelessness Essentials',
        'Hygiene',
        'Toilet',
        'Shower',
        'Hygiene Supplies',
        'Waste Disposal',
        'Water',
        'Storage',
        'Drug Related Services',
        'Government Homelessness Services',
        'Technology',
        'Wifi Access',
        'Computer Access',
        'Smartphones',
        'Family Shelters',
        'Domestic Violence Shelters',
        'Eviction Defense',
        'Housing/Tenants Rights',
        'Youth',
        'Seniors',
        'End of Life Care',
        'Home Delivered Meals',
        'Senior Centers',
        'Congregate Meals',
        'Housing Rights',
        'Domestic Violence',
        'Legal Representation',
        'Prison/Jail Related Services',
        'Legal Services',
        'Domestic Violence Hotlines',
        'Re-entry Services',
        'Clean Slate',
        'Probation and Parole',
        'MOHCD Funded Services',
        'Basic Needs & Shelter',
        'Health & Medical',
        'Employment',
        'sffamilies',
        'Covid Shelter'
      ].freeze

      TOP_LEVEL_CATEGORY_NAMES = [
        'Emergency',
        'Food',
        'Housing',
        'Goods',
        'Transit',
        'Health',
        'Money',
        'Care',
        'Education',
        'Work',
        'Legal',
        'Homelessness Essentials',
        'Youth',
        'Seniors',
        'Domestic Violence',
        'Prison/Jail Related Services',
        'MOHCD Funded Services',
        'Eviction Defense',
        'Temporary Shelter',
        'sffamilies',
        'Covid Shelter'
      ].freeze

      FEATURED_CATEGORY_NAMES = [
        'Basic Needs & Shelter',
        'Housing',
        'Health & Medical',
        'Employment',
        'Legal'
      ].freeze

      CHILD_CATEGORY_NAMES = [
        'Legal Representation',
        'Legal Services',
        'Probation and Parole'
      ].freeze

      ELIGIBILITY_NAMES = [
        'Seniors (55+ years old)', 'Veterans', 'Families',
        'Transition Aged Youth',
        'Re-Entry',
        'Immigrants',
        'Foster Youth',
        'Near Homeless',
        'LGBTQ',
        'Alzheimers',
        'Homeless',
        'Disabled',
        'Low-Income'
      ].freeze

      ELIGIBILITY_FEATURE_RANKS = {
        'Seniors (55+ years old)' => 1,
        'Veterans' => 2,
        'Families' => 3,
        'Transition Aged Youth' => 4,
        'Re-Entry' => 5,
        'Immigrants' => 6
      }.freeze

      ELIGIBILITY_RESOURCE_COUNTS = {
        'Seniors (55+ years old)' => 24,
        'Veterans' => 17,
        'Families' => 8,
        'Transition Aged Youth' => 24,
        'Re-Entry' => 17,
        'Immigrants' => 8
      }.freeze
    end
  end

  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/MethodLength
end
