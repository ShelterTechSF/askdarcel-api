# frozen_string_literal: true

# Visits all Resources that have been updated since the last time this job ran.
# Syncs these resources and all of their services to Algolia.
#
# Stores a bookmark, allowing it to pick up where it left off last time and
# query for recently updated Resources.
#
# Saves approved Resources and Services to Algolia, removes all others from
# Algolia.
#
# Usage:
#
#   > AlgoliaIncrementalIndexJob.new.perform
#
class AlgoliaIncrementalIndexJob
  BATCH_SIZE = 50
  BOOKMARK_IDENTIFIER = 'algolia-incremental-index-resources-bookmark'

  def perform
    Rails.logger.info('Beginning incremental index of updated resources and their services...')
    bookmark = find_or_create_bookmark
    resource_counts = { updated: 0, removed: 0 }
    service_counts = { updated: 0, removed: 0 }
    scan_through_recently_updated_resources(bookmark) do |resource|
      process_resource(resource, resource_counts, service_counts)
    end
    Rails.logger.info("Done. resource counts: #{resource_counts}, service counts: #{service_counts}")
  end

  private

  def process_resource(resource, resource_counts, service_counts)
    process_record(resource, resource_counts)
    resource.services.each do |service|
      process_record(service, service_counts)
    end
  end

  def process_record(record, counts)
    if record.approved?
      update_in_algolia!(record)
      counts[:updated] += 1
    else
      remove_from_algolia!(record)
      counts[:removed] += 1
    end
  end

  def find_or_create_bookmark
    Bookmark.create_with(date_value: 20.years.ago, id_value: 0)
            .find_or_create_by(identifier: BOOKMARK_IDENTIFIER)
  end

  def scan_through_recently_updated_resources(bookmark, &block)
    loop do
      batch = query_next_batch(bookmark)
      break if batch.empty?

      batch.each(&block)
      last = batch.last
      bookmark.update(date_value: last.updated_at, id_value: last.id)
      Rails.logger.info("Bookmark updated. #{bookmark.identifier} - "\
                        "date_value: #{bookmark.date_value}, "\
                        "id_value: #{bookmark.id_value}")
    end
  end

  def query_next_batch(bookmark)
    uat = bookmark.date_value
    id = bookmark.id_value
    Resource.where('(updated_at, id) > (:updated_at, :id)', updated_at: uat, id: id)
            .order(Arel.sql('(updated_at, id) ASC'))
            .limit(BATCH_SIZE)
            .to_a
  end

  def update_in_algolia!(record)
    return unless Rails.configuration.x.algolia.enabled

    record.index!
  end

  def remove_from_algolia!(record)
    return unless Rails.configuration.x.algolia.enabled

    record.remove_from_index!
  end
end
