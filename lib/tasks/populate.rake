# frozen_string_literal: true

namespace :db do
  desc 'Erase and fill a development database using fixtures'
  task populate: :environment do
    unless Rails.env.development? || Rails.env.test?
      puts 'db:populate task can only be run in development or test.'
      exit
    end
    require 'sheltertech/db/fixture_populator'
    ShelterTech::DB::FixturePopulator.populate
  end

  desc 'Import copy of staging database'
  task import_staging: :environment do
    unless Rails.env.development?
      puts 'db:import_staging task can only be run in development env'
      exit
    end

    require 'sheltertech/db/staging_importer'
    ShelterTech::DB::StagingImporter.populate
  end
end
