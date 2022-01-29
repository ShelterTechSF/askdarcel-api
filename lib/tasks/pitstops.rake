# frozen_string_literal: true

# lib/tasks/pitstops.rake
# invoke on command line from root directory of repo by running
# `bundle exec rake pitstops:import`
# or with the docker setup with
# `docker-compose run --rm api rake pitstops:import`
# you can also run on a production server by running
# `bundle exec rake pitstops:import RAILS_ENV=production`

require 'json'

namespace :pitstops do
  task import: :environment do
    puts '[pitstops:import] Incorporating pitstops from JSON...'

    geodata = JSON.parse(File.read(File.join(File.dirname(__FILE__),
                                             'Pit_Stops__Hand_Washing_Stations.json')), symbolize_names: true)

    category_names = %w[covid-delivery covid-food covid-hygiene covid-jobs-finances covid-quarantine covid-shelter-not-working]

    category_names.each do |name|
      FactoryBot.create(:category, name: name, top_level: true)
    end

    # the city wasn't in our database as an org, so this adds it so the pit stops & hand washing stations
    #  can belong to the proper org and service
    resource = Resource.new
    resource.name = 'City of San Francisco'
    resource.website = 'https://sf.gov/'
    resource.long_description = 'The City'
    resource.status = :approved
    puts "adding #{resource.name}"
    puts "resource description is :#{resource.long_description}"

    # pitstops and handwashing are each a service of the City
    pitstops = resource.services.build
    handwashing = resource.services.build

    pitstops.name = 'Pit Stops'
    handwashing.name = 'Hand Washing Station'

    pitstops.long_description = 'Pit Stops include toilets, sinks, needle disposal, and dog waste stations.'
    handwashing.long_description = 'Hand Washing Stations to support hand hygiene and reduce the spread of COVID-19.'

    pitstops.status = :approved
    handwashing.status = :approved

    cat = Category.where('name = ?', 'covid-hygiene').first

    pitstops.categories << cat
    handwashing.categories << cat

    pitstops.schedule = Schedule.new
    handwashing.schedule = Schedule.new
    # add estimated hours to actual Service schedule
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    # 9am to 8pm is the most common open time for pit stops, individual location times differ so we add those hours to notes below
    days.each do |day|
      pitstops.schedule.schedule_days.build(opens_at: 900, closes_at: 2000, day: day)
    end
    # handwashing stations are all 24/7
    days.each do |day|
      handwashing.schedule.schedule_days.build(opens_at: 0, closes_at: 2359, day: day)
    end
    resource.schedule = handwashing.schedule

    pitstops.addresses = []
    handwashing.addresses = []

    note_p = pitstops.notes.build
    note_h = handwashing.notes.build
    note_p.note = ''
    note_h.note = ''

    geodata[:features].each do |location|
      address = Address.new
      address.city = 'San Francisco'
      address.address_1 = location[:properties][:Name]
      address.state_province = 'CA'
      address.postal_code = ''
      address.latitude = location[:properties][:Latitude]
      address.longitude = location[:properties][:Longitude]

      if location[:properties][:Site_Type] == "Pit Stop"
        pitstops.addresses << address
        # Since Pit Stops have varying hours, append actual location's hours to Service Notes
        note_p.note += "#{location[:properties][:Neighborhood]}: #{location[:properties][:Name]}\n"
        note_p.note += "#{location[:properties][:Hours_of_Operation]}\n\n"
      else
        handwashing.addresses << address
      end
    end

    resource.save!

    puts '[pitstops:import] Complete.'
  end
end
