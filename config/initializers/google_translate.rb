# frozen_string_literal: true

if Rails.configuration.x.google.translate_credentials
  Rails.configuration.x.google.translation_enabled = true
  TranslationService = Google::Cloud::Translate.translation_service
end
