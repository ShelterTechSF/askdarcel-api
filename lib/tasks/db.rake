# frozen_string_literal: true

namespace :db do
  namespace :data do
    task :dump, [:filename] => :environment do |_t, args|
      args.with_defaults(filename: 'db.sql')
      DBTasks.set_psql_env!
      raise "Error dumping database" unless system("pg_dump --file '#{args.filename}'")
    end

    task :load, [:filename] => :environment do |_t, args|
      raise 'Refusing to run in production!' if Rails.env.production?
      args.with_defaults(filename: 'db.sql')
      DBTasks.set_psql_env!
      raise "Error loading database" unless system("psql < '#{args.filename}'")
    end
  end
end

# Adapted from ActiveRecord::Tasks::PostgreSQLDatabaseTasks
class DBTasks
  def self.set_psql_env!
    config = ActiveRecord::Base.connection_config
    ENV['PGHOST'] = config[:host] if config[:host]
    ENV['PGPORT'] = config[:port].to_s if config[:port]
    ENV['PGPASSWORD'] = config[:password] if config[:password]
    ENV['PGUSER'] = config[:username] if config[:username]
    ENV['PGDATABASE'] = config[:database] if config[:database]
  end
end
