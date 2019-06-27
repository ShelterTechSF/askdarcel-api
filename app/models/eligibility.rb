# frozen_string_literal: true

# Schema description:
#
# name [ String ] Name of the eligibility, eg. "Veterans". Must be present and
# unique.
#
# feature_rank [ Integer or nil ] If present, will be featured on the landing
# page. Featured eligibilities on the landing page are sorted by feature_rank
# in ascending order.
#
# created_at [ DateTime ] when created
#
# updated_at [ DateTime ] when last updated
#
class Eligibility < ApplicationRecord
  has_and_belongs_to_many :services

  validates :name, presence: true
end
