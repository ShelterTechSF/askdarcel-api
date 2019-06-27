# frozen_string_literal: true

namespace :algolia do
  task reindex: :environment do
    puts '[algolia:reindex] Reindexing resource/service index...'
    AlgoliaReindexJob.new.perform
    puts '[algolia:reindex] Success.'
  end
end
