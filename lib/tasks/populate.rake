namespace :db do
  desc 'Erase and fill a development database'
  task populate: :environment do
    unless Rails.env.development?
      puts 'db:populate task can only be run in development.'
      exit
    end

    require 'faker/sheltertech'

    [Review, Rating, User, Note, ScheduleDay, Schedule, Phone, Address, Category, Service, Resource].each(&:delete_all)
    [FieldChange, ChangeRequest].each(&:delete_all)
    category_names = %w(Shelter Food Medical Hygiene Technology Money)

    6.times do |i|
      FactoryGirl.create(:category, name: category_names[i])
    end

    categories = Category.all

    admin = Admin.new
    admin.email = 'dev-admin@sheltertech.org'
    admin.password = 'dev-test-01'
    admin.save

    128.times do
      name = Faker::Company.name
      short_description = Faker::Lorem.sentence if rand(2) == 0
      long_description = Faker::ShelterTech.description
      website = Faker::Internet.url if rand(2) == 0
      services = []

      (rand(2) + 1).times do
        services.push(FactoryGirl.create(:service,
                                         long_description: Faker::ShelterTech.description))

        resource = FactoryGirl.create(:resource,
                                      name: name,
                                      short_description: short_description,
                                      long_description: long_description,
                                      website: website,
                                      categories: categories.sample(rand(4)),
                                      services: services)

        FactoryGirl.create(:change_request,
                           type: 'ResourceChangeRequest',
                           status: ChangeRequest.statuses[:pending],
                           object_id: resource.id)
      end
    end

    resources = Resource.all

    64.times do
      user = FactoryGirl.create(:user)

      resources.sample(rand(8)).each do |resource|
        FactoryGirl.create(:rating, resource: resource, user: user)
      end
    end
  end
end
