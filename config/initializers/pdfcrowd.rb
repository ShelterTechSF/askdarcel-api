# frozen_string_literal: true

if Rails.configuration.x.pdfcrowd.api_key && Rails.configuration.x.pdfcrowd.username
  Rails.configuration.x.pdfcrowd.enabled = true
  module PdfCrowdClient
    class << self; attr_accessor :client; end
  end

  PdfCrowdClient.client = Pdfcrowd::HtmlToPdfClient.new(
    Rails.configuration.x.pdfcrowd.username,
    Rails.configuration.x.pdfcrowd.api_key
  )
end
