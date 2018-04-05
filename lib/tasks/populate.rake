# frozen_string_literal: true

namespace :db do
  desc 'Erase and fill a development database'
  task populate: :environment do
    unless Rails.env.development? || Rails.env.test?
      puts 'db:populate task can only be run in development or test.'
      exit
    end

    require 'faker/sheltertech'

    Rails.application.eager_load! # Load all models
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.descendants.each do |model|
        next if model.to_s == 'ApplicationRecord'
        next if model.to_s.starts_with? 'ActiveRecord::'
        model.destroy_all
        ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
      end
    end

    category_names = [
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
    ]
    category_names.each { |name| FactoryGirl.create(:category, name: name) }

    top_level_categories = [
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
    ]
    top_level_categories.each do |c|
      Category.find_by_name!(c).update(top_level: true)
    end

    categories = Category.all
    top_level_categories = Category.where(top_level: true)

    FactoryGirl.create(:admin)

    128.times do
      name = Faker::Company.name
      short_description = Faker::Lorem.sentence if rand(2).zero?
      long_description = Faker::ShelterTech.description
      website = Faker::Internet.url if rand(2).zero?
      resource = FactoryGirl.create(:resource,
                                    name: name,
                                    short_description: short_description,
                                    long_description: long_description,
                                    website: website,
                                    categories: top_level_categories.sample(rand(2)) + categories.sample(rand(2)))
      services = []

      rand(1..2).times do
        service_categories = top_level_categories.sample(rand(2)) + categories.sample(rand(2))
        services << FactoryGirl.create(:service,
                                       resource: resource,
                                       long_description: Faker::ShelterTech.description,
                                       categories: service_categories)

        FactoryGirl.create(:change_request,
                           type: 'ResourceChangeRequest',
                           status: ChangeRequest.statuses[:pending],
                           object_id: resource.id)
      end

      resource.services = services
    end

    1.times do
      test_category_names = ['Test_Category_Top_Level']
      test_category_names.each { |name| FactoryGirl.create(:category, name: name, id: 234) }
      Category.find_by_name!('Test_Category_Top_Level').update(top_level: true)
      test_categories = Category.where(name: test_category_names)

      resource = FactoryGirl.create(:resource,
                                    name: "A Test Resource",
                                    short_description: "I am a short description of a resource.",
                                    long_description: "I am a long description of a resource.",
                                    website: "www.fakewebsite.org",
                                    categories: [test_categories[0]])
      services = []

      1.times do
        services << FactoryGirl.create(:service,
                                       name: "A Test Service",
                                       resource: resource,
                                       long_description: "I am a long description of a service.",
                                       categories: [test_categories[0]])
        FactoryGirl.create(:change_request,
                           type: 'ResourceChangeRequest',
                           status: ChangeRequest.statuses[:pending],
                           object_id: resource.id)
      end
      resource.services = services
    end
  end
end
