module Resources
  class Search
    SEARCH_CONFIG = 'english'.freeze

    # SEARCH_COLUMNS maps table names to an array of the columns in
    # that table to search.
    SEARCH_COLUMNS = {
      resources: %i(
        name
        short_description
        long_description
        website
      ).freeze,
      services: :long_description,
      notes: :note,
      categories: :name
    }.freeze

    CLAUSE = SEARCH_COLUMNS.map do |t, cols|
      Array.wrap(cols).map do |c|
        "to_tsvector('#{SEARCH_CONFIG}', coalesce(#{t}.#{c}, ''))"
      end
    end.flatten.join('||').freeze

    def self.perform(query, sort, scope: Resource)
      sort = 'resources.name' unless sort

      scope
        .left_outer_joins(:services)
        .left_outer_joins(:notes)
        .left_outer_joins(:categories)
        .left_outer_joins(:address)
        .where("#{CLAUSE} @@ plainto_tsquery('#{SEARCH_CONFIG}', ?)", query)
        .where('status' => :approved)
        .group('resources.id, addresses.latitude, addresses.longitude')
        .order(sort)
    end
  end
end
