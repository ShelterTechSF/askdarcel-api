# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe "#round_time" do
    before(:example) do
      @schedule = build(:schedule)
    end

    it "rounds 0 to 0" do
      expect(@schedule.send(:round_time, 0, 30, :down)).to eq(0)
      expect(@schedule.send(:round_time, 0, 30, :up)).to eq(0)
    end

    it "rounds down properly" do
      expect(@schedule.send(:round_time, 1, 15, :down)).to eq(0)
      expect(@schedule.send(:round_time, 14, 15, :down)).to eq(0)
      expect(@schedule.send(:round_time, 15, 15, :down)).to eq(15)
    end

    it "rounds up properly" do
      expect(@schedule.send(:round_time, 1, 15, :up)).to eq(15)
      expect(@schedule.send(:round_time, 14, 15, :up)).to eq(15)
      expect(@schedule.send(:round_time, 15, 15, :up)).to eq(15)
    end
  end

  describe "#format_algolia_open_time" do
    it "formats properly" do
      schedule = build(:schedule)
      expect(schedule.send(:format_algolia_open_time, 'Tuesday', 945)).to eq('Tu-15:45')
      expect(schedule.send(:format_algolia_open_time, 'Wednesday', 120)).to eq('W-2:00')
      expect(schedule.send(:format_algolia_open_time, 'Sunday', 0)).to eq('Su-0:00')
      expect(schedule.send(:format_algolia_open_time, 'Friday', 270)).to eq('F-4:30')
    end
  end

  describe "#algolia_open_times" do
    it "formats properly" do
      schedule = build(:schedule, schedule_days: [
                         build(:schedule_day, day: 'Thursday', opens_at: 1300, closes_at: 1400),
                         build(:schedule_day, day: 'Wednesday', opens_at: 945, closes_at: 1515)
                       ])
      expect(schedule.algolia_open_times).to match_array(%w[
                                                           W-9:30
                                                           W-10:00
                                                           W-10:30
                                                           W-11:00
                                                           W-11:30
                                                           W-12:00
                                                           W-12:30
                                                           W-13:00
                                                           W-13:30
                                                           W-14:00
                                                           W-14:30
                                                           W-15:00
                                                           Th-13:00
                                                           Th-13:30
                                                         ])
    end

    it "handles nil times properly" do
      schedule = build(:schedule, schedule_days: [
                         build(:schedule_day, day: 'Thursday', opens_at: nil, closes_at: 1400),
                         build(:schedule_day, day: 'Wednesday', opens_at: 945, closes_at: nil),
                         build(:schedule_day, day: 'Friday', opens_at: 900, closes_at: 930)
                       ])
      expect(schedule.algolia_open_times).to match_array(%w[F-9:00])
    end
  end
end
