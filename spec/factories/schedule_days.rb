# frozen_string_literal: true

require 'sheltertech/random'

FactoryBot.define do
  factory :schedule_day do
    day { "Monday" }
    opens_at { ShelterTech::Random.time(600, 1000) }
    closes_at { ShelterTech::Random.time(1400, 2400) }
    schedule { nil }

    factory :late_schedule_day do
      opens_at { ShelterTech::Random.time(1400, 2300) }
      closes_at { ShelterTech::Random.time(100, 400) }
    end
  end
end
