# frozen_string_literal: true

module ShelterTech
  module DB
    # Utility class to import a copy of staging database into local env.
    # rubocop: disable Metrics/ClassLength
    class StagingImporter
      def self.populate
        password = ENV['STAGING_DB_PASSWORD']
        raise ArgumentError, 'STAGING_DB_PASSWORD env variable missing' unless password.present?

        # Import staging database to local env
        log_progress('Importing staging database to local env...')
        import_staging_database!(password)

        # Reindex all algolia records
        log_progress('Reindexing all algolia records. Expected time: 1-3 minutes.')
        log_progress('Note: This does not log progress.')
        AlgoliaReindexJob.new.perform

        log_progress('Done!')
      end

      def self.import_staging_database!(password)
        local_db_config = ActiveRecord::Base.connection_config

        staging_config = local_db_config.deep_dup
        staging_config[:host] = '35.197.79.154'
        staging_config[:database] = 'askdarcel'
        staging_config[:username] = 'master'
        staging_config[:password] = password

        import_tables!(local_db_config, staging_config)
      end

      def self.import_tables!(local_db_config, staging_config)
        # Read tables from staging DB into memory
        ActiveRecord::Base.establish_connection(staging_config)
        table_records = read_table_records(compute_tables_to_copy)

        # Write staging tables from memory to local DB
        ActiveRecord::Base.establish_connection(local_db_config)
        begin
          # Temporarily disable foreign key constraints
          ActiveRecord::Base.connection.execute('SET session_replication_role = replica;')
          execute_tables_import!(table_records)
        ensure
          # Re-enable foreign key constraints
          ActiveRecord::Base.connection.execute('SET session_replication_role = DEFAULT;')
        end
        # Update all ID sequences. Necessary for performing new INSERTs.
        update_id_sequences!
      end

      def self.table_exists(table_name)
        ActiveRecord::Base.connection.execute("select exists "\
                                              "(select 1 from information_schema.tables "\
                                              "where table_schema = 'public' "\
                                              "and table_name = '#{table_name}')")
                          .field_values('exists')
                          .all? { |r| ActiveRecord::Type::Boolean.new.cast(r) }
      end

      def self.read_table_records(tables_to_copy)
        # TODO(cliff): Right now, database is small enough to fit in memory
        # easily. In future, we should update our image's version of `pg_dump`
        # to match server's version of postgres and use that instead.
        log_progress('Copying data from staging database into memory. Expected time: 1 minute')
        tables_to_copy.each_with_index.map do |table_name, i|
          log_progress("Copying from staging: #{table_name} (#{i + 1}/#{tables_to_copy.size})...")
          if table_exists(table_name)
            # return table with all records if exists
            [table_name, ActiveRecord::Base.connection.execute("select * from #{table_name}").to_a]
          else
            log_progress("  #{table_name} does not exist in staging, skipping...")
            # else return an empty table
            [table_name, []]
          end
        end
      end

      def self.create_import_stats(table_records)
        total_records = table_records.map(&:last).map(&:size).sum
        {
          tables_count: table_records.size,
          total_save_count: 0,
          total_records: total_records,
          # From experiments, average write rate on laptop is 450 records per
          # second.
          started_at: ::Time.now,
          expected_end: (total_records / 450.0).seconds.from_now
        }
      end

      def self.execute_tables_import!(table_records)
        stats = create_import_stats(table_records)
        log_progress('Saving staging data from memory into local database.')
        log_progress("Expected time left: #{time_left!(stats)}")
        table_records.each_with_index do |(table_name, records), i|
          execute_table_import!(table_name, records, i + 1, stats)
        end
      end

      def self.execute_table_import!(table_name, records, table_number, stats)
        table_description = "#{table_name} (#{table_number}/#{stats[:tables_count]})"
        records.each_with_index do |record, i|
          fast_insert!(table_name, record)
          log_record_stats(table_description, i + 1, records.size, stats)
        end
        log_table_done(table_description, records.size, stats)
      end

      def self.log_record_stats(table_description, record_number, records_count, stats)
        stats[:total_save_count] += 1
        return unless (record_number % 250).zero?

        log_progress("#{table_description} - Saved #{record_number}/#{records_count} for table, "\
                     "#{stats[:total_save_count]}/#{stats[:total_records]} overall")
        return unless (record_number % 5000).zero?

        log_progress("Expected time left: #{time_left!(stats)}")
      end

      def self.log_table_done(table_description, records_count, stats)
        log_progress("#{table_description} - Done saving #{records_count} records for table, "\
                     "#{stats[:total_save_count]}/#{stats[:total_records]} overall")
        log_progress("Expected time left: #{time_left!(stats)}")
      end

      def self.compute_tables_to_copy
        # Load all models
        Rails.application.eager_load!
        ret = []
        ActiveRecord::Base.descendants.each do |model|
          model_name = model.to_s
          # Leave out built-in tables, like schema migrations
          next if model_name == 'ApplicationRecord'
          next if model_name.starts_with? 'ActiveRecord::'

          ret << model.table_name
        end
        ret.uniq
      end

      def self.update_id_sequences!
        table_name_query = "SELECT table_name FROM information_schema.tables WHERE table_schema='public'"
        results = ActiveRecord::Base.connection.execute(table_name_query).to_a
        table_names = results.map { |r| r['table_name'] }
        table_names.each do |table_name|
          id_sequence = lookup_id_sequence_name(table_name)
          next unless id_sequence.present?

          ActiveRecord::Base.connection.execute("SELECT setval('#{id_sequence}', MAX(id)) FROM #{table_name}")
        end
      end

      def self.lookup_id_sequence_name(table_name)
        result = ActiveRecord::Base.connection.execute("select pg_get_serial_sequence('#{table_name}', 'id')").to_a.first
        return nil unless result.present?

        result['pg_get_serial_sequence'].gsub('public.', '')
      rescue ActiveRecord::StatementInvalid
        nil
      end

      def self.time_left!(stats)
        seconds = update_time_left!(stats)
        return '0 seconds' if seconds.zero?

        ret = []
        if seconds >= 60
          minutes = seconds / 60
          ret << "#{minutes} minutes"
          seconds -= 60 * minutes
        end
        ret << "#{seconds} seconds" if seconds.positive?
        ret.join(', ')
      end

      def self.update_time_left!(stats)
        if stats[:total_save_count].zero?
          seconds_left = stats[:expected_end].to_i - ::Time.now.to_i
          return seconds_left
        end
        seconds_left = compute_seconds_left(stats)
        stats[:expected_end] = seconds_left.seconds.from_now
        seconds_left.to_i
      end

      def self.compute_seconds_left(stats)
        now = ::Time.now
        duration_so_far = now.to_f - stats[:started_at].to_f
        save_rate = stats[:total_save_count] / duration_so_far
        records_remaining = stats[:total_records] - stats[:total_save_count]
        records_remaining / save_rate
      end

      # Avoid slow Rails hooks by simply running sanitized SQL queries
      # directly. 5x performance improvement: import took 15 minutes using
      # standard ActiveRecord methods, but only 3 minutes using raw SQL
      # queries.
      def self.fast_insert!(table_name, record)
        keys = record.keys
        conn = ActiveRecord::Base.connection
        values = keys.map { |k| record[k] }
        quoted_table = conn.quote_table_name(table_name)
        quoted_keys  = keys.map { |k| conn.quote_column_name(k) }
        question_marks = Array.new(values.size, '?')
        sql_query = [
          "INSERT INTO #{quoted_table} (#{quoted_keys.join(', ')}) VALUES (#{question_marks.join(', ')})"
        ]
        sql_query += values
        sql_query = ActiveRecord::Base.send(:sanitize_sql_array, sql_query)
        conn.execute(sql_query)
      end

      def self.log_progress(msg)
        puts "#{::Time.now} [import_staging] #{msg}"
      end
    end
    # rubocop: enable Metrics/ClassLength
  end
end
