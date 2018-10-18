# frozen_string_literal: true

require 'sheltertech/random'

FactoryBot.define do
  factory :schedule do
    resource { nil }

    after(:create) do |schedule|
      days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
      days.each do |day|
        num_schedule_days = ShelterTech::Random.sample_weighted(
          0 => 1,
          1 => 3,
          2 => 1
        )
        schedule_day_strategies = {
          schedule_day: 4,
          late_schedule_day: 1
        }

        case num_schedule_days
        when 1
          schedule_day_factory = ShelterTech::Random.sample_weighted(schedule_day_strategies)
          create(schedule_day_factory, day: day, schedule: schedule)
        when 2
          # Make sure schedule days do not overlap in time by generating 4
          # random times and selecting disjoint ranges.
          times = nil
          loop do
            times = Array.new(4) { ShelterTech::Random.time }.uniq
            break if times.length == 4
          end
          times.sort!
          times.rotate! if ShelterTech::Random.sample_weighted(schedule_day_strategies) == :late_schedule_day
          create(:schedule_day, day: day, opens_at: times[0], closes_at: times[1], schedule: schedule)
          create(:schedule_day, day: day, opens_at: times[2], closes_at: times[3], schedule: schedule)
        end
      end
    end
  end
end
