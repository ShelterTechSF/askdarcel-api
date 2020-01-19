# frozen_string_literal: true

class SynonymGroup < ApplicationRecord
  enum group_type: { synonym: 0, oneWaySynonym: 1, altCorrection1: 2, altCorrection2: 3, placeholder: 4 }
end
