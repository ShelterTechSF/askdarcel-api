# frozen_string_literal: true

class Category < ActiveRecord::Base
  has_and_belongs_to_many :resources
  has_and_belongs_to_many :services
  has_and_belongs_to_many :keywords

  has_and_belongs_to_many(:categories,
                          join_table: "category_relationships",
                          foreign_key: "parent_id",
                          association_foreign_key: "child_id")
end
