# frozen_string_literal: true

require 'csv'

namespace :sffamilies do
  desc('Associate resources to the sffamilies site based on service(s) with sffamilies category tag')
  task associate_resources_with_site: :environment do
    # Ensure that the sffamilites sites exist
    Site.transaction do
      sffamilies = Site.find_or_create_by(site_code: 'sffamilies')
      puts "Site Id: #{sffamilies.id}, Site Code: #{sffamilies.site_code}"

      Resource.transaction do
        # Find services that have the 'sffamilies' category name tag
        services = Service.joins(:categories).where(categories: { name: 'sffamilies' })
        services.each do |service|
          puts("Service id : #{service.id}, Service name: #{service.name} " \
          "from Resource id #{service.resource_id} has sffamilies category tag")

          # If the parent resource of the sffamilies service is not
          # connected to the site, append the site to it's list
          resource = Resource.find_by(id: service.resource_id)
          unless resource.sites.include?(sffamilies)
            puts "Adding site association"
            new_sites = resource.sites.append(sffamilies)
            Resource.update(resource.id, sites: new_sites)
          end

          # Provide an updated list of the sites for the parent resource
          resource.sites.each do |resource_site|
            puts "#{resource_site.id}: #{resource_site.site_code}"
          end
        end
      end
    end
  end

  task assign_tags_to_services: :environment do
    dirname = 'sffamilies'
    Service.transaction do
      # Parse the service to tags map
      CSV.foreach(File.join('lib', dirname, 'services_to_tags.csv'), \
                  col_sep: ';') do |row|
        resource_name = row[0]
        service_name = row[1]
        if resource_name.blank? || service_name.blank?
          # Ignore if these are empty
          next
        end

        categories_and_eligibilities = row[2..-1]
        # First identify the resource and service
        resource = Resource.find_by(name: resource_name)
        if resource.nil?
          puts("Resource '#{resource_name}' not found")
          next
        end
        service = Service.find_by(name: service_name, resource_id: resource.id)
        if service.nil?
          puts("Service '#{service_name}' from resource '#{resource_name}' not found")
          next
        end
        # Then identify the categories and eligibilities
        new_categories = service.categories
        new_eligibilities = service.eligibilities
        categories_and_eligibilities.each do |category_or_eligibility|
          next if category_or_eligibility.blank?

          # Determine whether this is a category or eligibility
          found_category = Category.find_by(name: category_or_eligibility)
          if found_category.nil?
            found_eligibility = Eligibility.find_by(name: category_or_eligibility)
            if found_eligibility.nil?
              warn("Tag '#{category_or_eligibility}' not found in existing data")
            else
              # Don't add if the eligibility has already been added
              new_eligibilities = new_eligibilities.append(found_eligibility) unless new_eligibilities.include?(found_eligibility)
              # Neither a category nor eligibility, log to stderr
            end
          else
            # Don't add if the category has already been added
            new_categories = new_categories.append(found_category) unless new_categories.include?(found_category)
          end
        end
        new_categories_str = new_categories.map(&:name)
        new_eligibilities_str = new_eligibilities.map(&:name)
        puts("Service: '#{service.name}' (#{service.id})")
        puts("  * from Resource: '#{resource.name}' (#{resource.id})")
        puts("  * assigned categories: #{new_categories_str}")
        puts("  * assigned eligibilities: #{new_eligibilities_str}")
        Service.update(service.id, categories: new_categories, eligibilities: new_eligibilities)
      end
    end
  end
end
