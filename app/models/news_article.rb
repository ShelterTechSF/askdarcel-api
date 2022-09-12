# frozen_string_literal: true

class NewsArticle < ActiveRecord::Base
  belongs_to :service
end
