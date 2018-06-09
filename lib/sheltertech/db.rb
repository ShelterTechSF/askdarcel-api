# frozen_string_literal: true

require 'faker/sheltertech'

module ShelterTech
  class DB
    class Populator
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
        reset_db
        create_users
        create_categories
        create_resources
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

      def create_categories
        Constants::CATEGORY_NAMES.each { |name| FactoryGirl.create(:category, name: name) }
        Constants::TOP_LEVEL_CATEGORY_NAMES.each do |c|
          Category.find_by_name!(c).update(top_level: true)
        end
      end

      def create_users
        FactoryGirl.create(:admin)
      end

      def create_resources
        resource_creator = ResourceCreator.new(categories: categories, top_level_categories: top_level_categories)
        128.times { resource_creator.create_random_resource }
        TestCafeResourceCreator.create
      end
    end

    class ResourceCreator
      def initialize(categories:, top_level_categories:)
        @top_level_categories = top_level_categories
        @categories = categories
      end

      def create_random_resource
        resource = FactoryGirl.create(:resource,
                                      name: Faker::Company.name,
                                      short_description: random_short_description,
                                      long_description: Faker::ShelterTech.description,
                                      website: random_website,
                                      categories: @top_level_categories.sample(rand(2)) + @categories.sample(rand(2)))

        resource.services = create_random_services(resource)
      end

      def random_short_description
        rand(2).zero? ? '' : Faker::Lorem.sentence
      end

      def random_website
        rand(2).zero? ? '' : Faker::Internet.url
      end

      def create_random_service(resource)
        service_categories = @top_level_categories.sample(rand(2)) + @categories.sample(rand(2))
        service = FactoryGirl.create(:service,
                                     resource: resource,
                                     long_description: Faker::ShelterTech.description,
                                     categories: service_categories)

        FactoryGirl.create(:change_request,
                           type: 'ResourceChangeRequest',
                           status: ChangeRequest.statuses[:pending],
                           object_id: resource.id)
        service
      end

      def create_random_services(resource)
        Array.new(rand(1..2)) { create_random_service(resource) }
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
        FactoryGirl.create(:category, name: 'Test_Category_Top_Level', id: 234, top_level: true)
      end

      def self.create_resource(test_category)
        FactoryGirl.create(:resource,
                           name: "A Test Resource",
                           short_description: "I am a short description of a resource.",
                           long_description: "I am a long description of a resource.",
                           website: "www.fakewebsite.org",
                           categories: [test_category])
      end

      def self.create_service(resource, test_category)
        FactoryGirl.create(:service,
                           name: "A Test Service",
                           resource: resource,
                           long_description: "I am a long description of a service.",
                           categories: [test_category])
      end

      def self.create_change_request(resource)
        FactoryGirl.create(:change_request,
                           type: 'ResourceChangeRequest',
                           status: ChangeRequest.statuses[:pending],
                           object_id: resource.id)
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
        'Clothing',
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
        'Probation and Parole'
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
        'Prison/Jail Related Services'
      ].freeze
    end
  end
end
