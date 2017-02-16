# lib/tasks/linksf.rake
# invoke on command line from root directory of repo by running
# `bundle exec rake linksf:import[path/to/linksf-dump.json]`
# you can also run on a production server by running
# `bundle exec rake linksf:import[path/to/linksf-dump.json] RAILS_ENV=production`

require 'json' # not sure if this is necessary in ruby 2.x, json might be part of stdlib now

namespace :linksf do
  task :import, [:filename] => :environment do |_t, args|
    args.with_defaults(filename: 'linksf-pretty.json')

    filename = './linksf.json'

    data = JSON.parse(File.read(filename), symbolize_names: true)

    # Drop the first element because it's just an integer count of the number
    # of resource records.

    category_names = %w(Shelter Food Medical Hygiene Technology Money)

    6.times do |i|
      FactoryGirl.create(:category, name: category_names[i])
    end

    # %w(Shelter Food Medical Hygiene Technology).each do |category|
    #  FactoryGirl.create(:category, name: category)
    # end

    days_of_week = %w(Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday)

    records = data[:result].drop(1)

    admin = Admin.new
    admin.email = 'dev-admin@sheltertech.org'
    admin.password = 'dev-test-01'
    admin.save

    records.each do |record|
      resource = Resource.new
      resource.name = record[:name]
      resource.website = record[:website]
      resource.long_description = record[:notes]

      category_name = record[:categories]
      category_name = 'shelter' if category_name == 'housing'

      puts 'adding ' + resource.name

      puts 'resource description is :' + resource.long_description

      if resource.long_description.blank? || resource.long_description.length < 15
        puts 'replacing bad description with nil'
        resource.long_description = nil
      end

      record[:services].each do |service_json|
        category_name = service_json[:category]
        category_name = 'shelter' if category_name == 'housing'
        cat = Category.where('lower(name) = ?', category_name).first

        resource.categories << cat
      end

      # cat = Category.where('lower(name) = ?', category_name).first
      # resource.categories << cat

      if record[:phoneNumbers].present?
        record[:phoneNumbers].each do |phone_number|
          next unless phone_number[:number].present?
          phone = resource.phones.build
          phone.country_code = 'US'
          phone.service_type = phone_number[:info]
          phone.number = phone_number[:number]
        end
      end

      # 7.times do |i|
      #  schedule_day = resource.schedule.schedule_days.build
      #  schedule_day.day = days_of_week[i]
      #  schedule_day.opens_at = record[:openHours].get[0]
      #  schedule_day.closes_at = record[:openHours].get[0]
      # end

      address = Address.new
      address.city = record[:city]
      address.address_1 = record[:address]
      address.state_province = 'CA'
      address.postal_code = Faker::Address.postcode
      address.country = 'USA'

      json_location = record[:location]
      address.latitude = json_location[:latitude]
      address.longitude = json_location[:longitude]
      resource.address = address

      record[:services].each do |json_service|
        service = resource.services.build
        service.name = json_service[:name]
        service.long_description = json_service[:description]

        if record[:notes].present?
          note = service.notes.build
          note.note = record[:notes]
        end

        service.schedule = Schedule.new

        resource.schedule = service.schedule

        category_name = json_service[:category]
        category_name = 'shelter' if category_name == 'housing'
        cat = Category.where('lower(name) = ?', category_name).first

        service.categories << cat

        next unless json_service[:openHours].present?
        json_service[:openHours].each do |key, value|
          open = value[0][0] / 100
          close = value[0][1] / 100
          service.schedule.schedule_days.build(opens_at: open, closes_at: close, day: days_of_week[key.to_s.to_i])
        end
      end

      # ...

      resource.save!

      resource.services.each do |service|
        change_request = ChangeRequest.new
        change_request.object_id = service.id

        change_request.type = 'ServiceChangeRequest'
        change_request.status = ChangeRequest.statuses[:pending]

        change_request.resource = resource

        field_change = change_request.field_changes.build
        field_change.field_name = 'name'
        field_change.field_value = service.name + '(changed)'

        field_change = change_request.field_changes.build
        field_change.field_name = 'long_description'
        field_change.field_value = if service.long_description.present?
                                     service.long_description + '(changed)'
                                   else
                                     '(changed)'
                                   end

        change_request.save!
      end

      change_request = ChangeRequest.new

      change_request.object_id = resource.id
      change_request.type = 'ResourceChangeRequest'
      change_request.status = ChangeRequest.statuses[:pending]

      change_request.resource = resource

      field_change = change_request.field_changes.build
      field_change.field_name = 'name'
      field_change.field_value = resource.name + '(changed)'

      field_change = change_request.field_changes.build
      field_change.field_name = 'long_description'
      field_change.field_value = if resource.long_description.present?
                                   resource.long_description + '(changed)'
                                 else
                                   '(changed)'
                                 end

      change_request.save!
    end
  end
end
