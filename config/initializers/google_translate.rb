# frozen_string_literal: true

if Rails.configuration.x.google.translate_credentials
  Rails.configuration.x.google.translation_enabled = true
  Rails.configuration.x.google.project_id = JSON.parse(Rails.configuration.x.google.translate_credentials)['project_id']
end
