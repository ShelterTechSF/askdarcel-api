# frozen_string_literal: true

class EligibilityRelationship < ActiveRecord::Base
  belongs_to :parent, class_name: :Eligibility
  belongs_to :child, class_name: :Eligibility
end
