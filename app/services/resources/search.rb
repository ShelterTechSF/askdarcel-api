# frozen_string_literal: true

module Resources
  module Search
    def self.perform(query, lat_lng: nil, scope: Resource)
      strategy = if Rails.configuration.x.algolia.enabled
                   AlgoliaStrategy
                 else
                   DatabaseStrategy
                 end
      strategy.perform(query, lat_lng, scope)
    end

    class SearchStrategy
      def self.perform(_query, _lat_lng, _scope)
        raise NotImplementedError
      end
    end

    class DatabaseStrategy < SearchStrategy
      SEARCH_CONFIG = 'english'

      # SEARCH_COLUMNS maps table names to an array of the columns in
      # that table to search.
      SEARCH_COLUMNS = {
        resources: %i[
          name
          short_description
          long_description
          website
        ].freeze,
        services: :long_description,
        notes: :note,
        categories: :name
      }.freeze

      CLAUSE = SEARCH_COLUMNS.map do |t, cols|
        Array.wrap(cols).map do |c|
          "to_tsvector('#{SEARCH_CONFIG}', coalesce(#{t}.#{c}, ''))"
        end
      end.flatten.join('||').freeze

      def self.perform(query, lat_lng, scope)
        sort = lat_lng.blank? ? 'resources.name' : Address.distance_sql(lat_lng)

        scope
          .left_outer_joins(services: [:categories])
          .left_outer_joins(:notes)
          .left_outer_joins(:categories)
          .left_outer_joins(:address)
          .where("#{CLAUSE} @@ plainto_tsquery('#{SEARCH_CONFIG}', ?)", query)
          .group('resources.id, addresses.latitude, addresses.longitude')
          .order(sort)
      end
    end

    class AlgoliaStrategy < SearchStrategy
      def self.perform(query, lat_lng, scope)
        opts = if lat_lng.blank?
                 {}
               else
                 {
                   aroundLatLng: "#{lat_lng.lat}, #{lat_lng.lng}",
                   aroundRadius: 20_000, # Meters
                 }
               end
        scope.algolia_search(query, opts)
      end
    end
  end
end
