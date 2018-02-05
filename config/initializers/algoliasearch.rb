# frozen_string_literal: true

if Rails.configuration.x.algolia.enabled
  AlgoliaSearch.configuration = {
    application_id: Rails.configuration.x.algolia.application_id,
    api_key: Rails.configuration.x.algolia.api_key
  }
end
