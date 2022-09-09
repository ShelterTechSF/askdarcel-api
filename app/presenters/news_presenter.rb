# frozen_string_literal: true

class NewsPresenter < Jsonite
  property :id
  property :headline
  property :effective_date
  property :body
  property :priority
  property :expiration_date
end
