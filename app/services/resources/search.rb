module Resources
  class Search
    def self.perform(query, sort, scope: Resource)
      scope.algolia_search(query)
    end
  end
end
