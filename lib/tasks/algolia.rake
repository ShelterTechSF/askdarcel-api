# frozen_string_literal: true

namespace :algolia do
  task reindex: :environment do
    print "Reindexing resource/service index... "
    Resource.reindex!
    Service.reindex!
    puts "success."
  end
end
