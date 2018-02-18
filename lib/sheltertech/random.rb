# frozen_string_literal: true

require_relative 'time'

module ShelterTech
  module Random
    ## Given a Hash mapping items to relative weights, randomly sample an item.
    def self.sample_weighted(weighted_items)
      sum = weighted_items.values.sum.to_f
      normalized_weights = weighted_items.map { |item, weight| [item, weight / sum] }
      normalized_weights.max_by { |_, weight| rand**(1.0 / weight) }.first
    end

    ## Return random time in our hhmm format
    def self.time(from = 0, to = 2400)
      # Convert time from hhmm to number of minutes since midnight
      from_minutes = Time.hhmm_to_minutes(from)
      to_minutes = Time.hhmm_to_minutes(to)

      # Bias minutes so that we only return times aligned to every quarter hour
      time = Faker::Number.positive(from_minutes / 15, to_minutes / 15) * 15

      Time.minutes_to_hhmm(time)
    end
  end
end
