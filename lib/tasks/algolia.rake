# frozen_string_literal: true

namespace :algolia do
  task reindex: :environment do
    print "Reindexing resources... "
    Resource.reindex
    puts "success."
  end
end
