# frozen_string_literal: true

class TranslationController < ApplicationController
  def translate_text
    # Accepts a string and translates to English
    require "google/cloud/translate/v3"

    client = ::Google::Cloud::Translate::V3::TranslationService::Client.new
    request = ::Google::Cloud::Translate::V3::TranslateTextRequest.new(translate_params)
    response = client.translate_text request
    Rails.logger.info(response.translations[0].translated_text)
    render json: {result: response.translations[0].translated_text}
  rescue Google::Cloud::ResourceExhaustedError
    error = StandardError.new "Sorry – we've hit our translation limit for the day. Please try again tomorrow. Contact \
support with any questions."
    raise error
  end

  def translate_params
    Rails.logger.info("whats going onhere ...")
    {
      contents: [params[:text]],
      target_language_code: 'en',
      source_language_code: params[:target_language],
      parent: "projects/#{Rails.configuration.x.google.project_id}"
    }
  end
end
