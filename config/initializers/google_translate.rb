# frozen_string_literal: true

# Rails.logger.info("6: #{Rails.configuration.x.google.translate_credentials}")
puts("6: #{Rails.configuration.x.google.translate_credentials}")

# if Rails.configuration.x.google.translate_credentials
if Rails.env.production? || Rails.env.staging?
  Rails.configuration.x.google.translation_enabled = true
  module CloudTranslation
    class << self; attr_accessor :project_id, :translation_service end
  end
  CloudTranslation.translation_service = Google::Cloud::Translate.translation_service
  CloudTranslation.project_id = "askdarcel-184805"
end
