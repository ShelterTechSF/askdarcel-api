namespace :db do
  desc 'Erase and fill a development database'
  task populate: :environment do
    unless Rails.env.development?
      puts 'db:populate task can only be run in development.'
      exit
    end

    [ScheduleDay, Schedule, Phone, Address, Category, Resource].each(&:delete_all)

    categories = %w(Shelter Food Medical Hygiene Technology)

    categories.each do |category|
      FactoryGirl.create(:category,
                         name: category)
    end

    categories = Category.all

    shelter_descriptions = [
      'Shelter for 1 or 2 parent families, expectant couples (with proof), and pregnant women in 7th month or 5th month with proof. Same-sex couples accepted. 1 night or 60 day beds.',
      '1-night bed and 24 hour drop-in showers and support services available. Doctors on site.',

      'First-come, first-serve; no reservations required but identification mandatory. No pets, no families. 1 day beds only.',

      '5 beds for women in crisis (rape or domestic violence); stay up to 7 days. 16 shelter beds; stay varies. 16 beds in supportive housing (5 for HIV+ women); stay up to 18 months. 8-bed substance abuse program for any woman 18+; stay 1-4 months.',

      'Operates on a drop-in basis. Members sign in between 12:30 and 1pm. People aree seen on a first-come, first-served basis. If you have them, bring ID, letter of diagnosis and proof of income. At this time, AHASF is unable to provide phone counseling, or e-mail counseling or to set up special appointments for intakes. During drop-in, they will perform an intake assessment and create an Individualized Housing Plan.'
    ]

    128.times do
      name = Faker::Company.name
      short_description = Faker::Lorem.sentence if rand(2) == 0
      long_description = shelter_descriptions[rand(5) - 1]
      # long_description = Faker::Lorem.paragraph if rand(2) == 0
      website = Faker::Internet.url if rand(2) == 0

      FactoryGirl.create(:resource,
                         name: name,
                         short_description: short_description,
                         long_description: long_description,
                         website: website,
                         categories: categories.sample(rand(4)))
    end
  end
end
