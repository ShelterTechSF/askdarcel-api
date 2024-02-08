# frozen_string_literal: true

class NewsArticle < ActiveRecord::Base
  scope :active, -> {
    where("(effective_date is null or effective_date <= ?) and (expiration_date is null or expiration_date >= ?)",
          Time.current, Time.current)
  }
end
