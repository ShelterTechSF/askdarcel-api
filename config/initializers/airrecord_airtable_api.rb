# frozen_string_literal: true

if Rails.configuration.x.airtable.api_key
  Airrecord.api_key = Rails.configuration.x.airtable.api_key

  class AirTableOrgs < Airrecord::Table
    self.base_key = "appItSYNzRjTx08hN"
    self.table_name = "AskDarcel Organizations"
  end
end
