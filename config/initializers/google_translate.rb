# frozen_string_literal: true

if Rails.configuration.x.google.translate_credentials
  Rails.configuration.x.google.translation_enabled = true
  module CloudTranslation
    class << self; attr_accessor :project_id, :translation_service end
  end
  CloudTranslation.translation_service = Google::Cloud::Translate.translation_service
  CloudTranslation.project_id = JSON.parse(Rails.configuration.x.google.translate_credentials)['project_id']
end
