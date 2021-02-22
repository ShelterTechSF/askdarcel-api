# frozen_string_literal: true

# Tasks to add default site code of 'sfsg' to all existing resources and categories

require_relative "../../app/models/application_record.rb"
require_relative "../../app/models/resource_site.rb"

namespace :create_site do
  # create site_code of 'sfsg'
  desc 'Creates a site for sfsg'
  task add_sfsg_site: :environment do
    Site.transaction do
      Site.find_or_create_by(site_code: 'sfsg')
    end
  end
  # to each resource, add a connection using resource_site
  desc 'Adds the sfsg site to existing resources'
  task add_sfsg_to_resources: :environment do
    sfsg_id = Site.find_by(site_code: 'sfsg').id
    Resource.transaction do
      Resource.all.each do |r|
        ResourcesSites.find_or_create_by(resource_id: r.id,
                                         site_id: sfsg_id)
      end
    end
  end

  # to each category, add a connection using category_site
  desc 'Adds the sfsg site to existing categories'
  task add_sfsg_to_categories: :environment do
    sfsg_id = Site.find_by(site_code: 'sfsg').id
    Category.transaction do
      Category.all.each do |c|
        CategoriesSites.find_or_create_by(category_id: c.id,
                                          site_id: sfsg_id)
      end
    end
  end
end
