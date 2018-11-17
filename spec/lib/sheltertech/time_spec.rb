# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShelterTech::Time do
  describe "hhmm_to_minutes" do
    it "converts correctly" do
      expect(ShelterTech::Time.hhmm_to_minutes(0)).to eq(0)
      expect(ShelterTech::Time.hhmm_to_minutes(30)).to eq(30)
      expect(ShelterTech::Time.hhmm_to_minutes(130)).to eq(90)
      expect(ShelterTech::Time.hhmm_to_minutes(300)).to eq(180)
      expect(ShelterTech::Time.hhmm_to_minutes(447)).to eq(287)
    end
  end

  describe "minutes_to_hhmm" do
    it "converts correctly" do
      expect(ShelterTech::Time.minutes_to_hhmm(0)).to eq(0)
      expect(ShelterTech::Time.minutes_to_hhmm(30)).to eq(30)
      expect(ShelterTech::Time.minutes_to_hhmm(90)).to eq(130)
      expect(ShelterTech::Time.minutes_to_hhmm(180)).to eq(300)
      expect(ShelterTech::Time.minutes_to_hhmm(287)).to eq(447)
    end
  end
end
