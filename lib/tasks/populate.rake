# frozen_string_literal: true

namespace :db do
  desc 'Erase and fill a development database'
  task populate: :environment do
    unless Rails.env.development? || Rails.env.test?
      puts 'db:populate task can only be run in development or test.'
      exit
    end
    require 'sheltertech/db'
    ShelterTech::DB::Populator.populate
  end
end
