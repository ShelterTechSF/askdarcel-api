# lib/tasks/linksf.rake
# invoke on command line from root directory of repo by running
# `bundle exec rake linksf:import[path/to/linksf-dump.json]`
# you can also run on a production server by running
# `bundle exec rake linksf:import[path/to/linksf-dump.json] RAILS_ENV=production`

require 'json' # not sure if this is necessary in ruby 2.x, json might be part of stdlib now
require 'phonelib'

namespace :linksf do
  task :import, [:dirname] => :environment do |_t, args|
    args.with_defaults(dirname: 'linksf')

    locations = JSON.parse(File.read(File.join(args.dirname, 'locations.json')), symbolize_names: true)
    organizations = JSON.parse(File.read(File.join(args.dirname, 'organizations.json')), symbolize_names: true)

    category_names = %w(Shelter Food Medical Hygiene Technology)

    category_names.each do |name|
      FactoryGirl.create(:category, name: name)
    end

    admin = Admin.new
    admin.email = 'dev-admin@sheltertech.org'
    admin.password = 'dev-test-01'
    admin.save

    # locations is an object with IDs as the keys, which we don't need
    locations.each_value do |location|
      # One of the locations has no services.
      next if location[:services].nil?

      organization = organizations[location[:organization_id].to_sym]
      resource = Resource.new
      resource.name = location[:name]
      resource.website = organization[:url]
      resource.long_description = location[:description]

      puts 'adding ' + resource.name

      puts 'resource description is :' + resource.long_description

      if resource.long_description.blank? || resource.long_description.length < 15
        puts 'replacing bad description with nil'
        resource.long_description = nil
      end
      # Once again, location[:services] is an object with IDs as the keys
      location[:services].each_value do |service_json|
        category_name = service_json[:taxonomy]
        category_name = 'shelter' if category_name == 'housing'
        cat = Category.where('lower(name) = ?', category_name).first

        resource.categories << cat
      end

      if organization[:phones].present?
        organization[:phones].each do |phone_number|
          next unless phone_number[:number].present?
          phone = resource.phones.build
          phone.service_type = phone_number[:department]
          phone.number = LinkSF.parse_number(phone_number[:number], 'US').full_e164
        end
      end

      address = Address.new
      address.city = location[:physical_address][:city]
      address.address_1 = location[:physical_address][:address_1]
      address.state_province = 'CA'
      address.postal_code = ''
      address.country = 'USA'

      address.latitude = location[:latitude]
      address.longitude = location[:longitude]
      resource.address = address

      location[:services].each_value do |json_service|
        service = resource.services.build
        service.name = json_service[:name]
        service.long_description = json_service[:description]
        service.status = :approved

        if json_service[:application_process].present?
          note = service.notes.build
          note.note = json_service[:application_process]
        end

        service.schedule = Schedule.new

        resource.schedule = service.schedule

        category_name = json_service[:taxonomy]
        category_name = 'shelter' if category_name == 'housing'
        cat = Category.where('lower(name) = ?', category_name).first

        service.categories << cat
        next unless json_service[:schedules].present?
        json_service[:schedules].each do |schedule|
          open = schedule[:opens_at] 
          close = schedule[:closes_at]
          service.schedule.schedule_days.build(opens_at: open, closes_at: close, day: schedule[:weekday])
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

class LinkSF
  def self.parse_number(number, country_code)
    try_plain_parse(number, country_code) ||
      try_ext_parse(number, country_code) ||
      try_area_code_parse(number, country_code)
  end

  def self.try_plain_parse(number, country_code)
    return unless Phonelib.valid_for_country?(number, country_code)
    Phonelib.parse(number, country_code)
  end

  def self.try_ext_parse(number, country_code)
    try_plain_parse(number.gsub(/ext.?\s*/, ';ext='), country_code)
  end

  def self.try_area_code_parse(number, country_code)
    return unless country_code == 'US' && Phonelib.parse(number, country_code).sanitized.length == 7
    number_to_area_code = {
      '227-0245' => '415'
    }
    unless number_to_area_code.key? number
      raise "Please manually check #{number}'s area code and add it to the list in this Raketask"
    end
    try_plain_parse(number_to_area_code[number] + number, country_code)
  end
end
