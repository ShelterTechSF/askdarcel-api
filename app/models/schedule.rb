# frozen_string_literal: true

require 'sheltertech/time'

class Schedule < ActiveRecord::Base
  belongs_to :resource, touch: true
  belongs_to :service
  has_many :schedule_days, dependent: :destroy

  accepts_nested_attributes_for :schedule_days

  # Format open times for use in Algolia index e.g. "M-8:00"
  def algolia_open_times
    schedule_days.flat_map(&method(:algolia_open_times_for_schedule_day))
  end

  private

  # Round time to the nearest block (e.g. round_time(89, 30, :down) == 60).
  # Time is represented as an absolute number of minutes since midnight for
  # simplicity.
  def round_time(minutes, block_size, direction)
    case direction
    when :down
      minutes / block_size * block_size
    when :up
      ((minutes - 1) / block_size + 1) * block_size
    else
      raise ArgumentError, "Invalid rounding direction: #{direction}"
    end
  end

  def algolia_open_times_for_schedule_day(day)
    return [] if day.opens_at.nil? || day.closes_at.nil?

    block_size = 30
    opens_at_minutes = ShelterTech::Time.hhmm_to_minutes(day.opens_at)
    closes_at_minutes = ShelterTech::Time.hhmm_to_minutes(day.closes_at)
    opens_at = round_time(opens_at_minutes, block_size, :down)
    closes_at = round_time(closes_at_minutes, block_size, :up)
    (opens_at...closes_at).step(block_size).map do |time|
      format_algolia_open_time(day.day, time)
    end
  end

  def format_algolia_open_time(day, time_in_minutes)
    time = Time.at(time_in_minutes * 60).getutc
    formatted_time = time.strftime("%k:%M").strip
    "#{day_abbreviation(day)}-#{formatted_time}"
  end

  def day_abbreviation(day)
    {
      'Monday' => 'M',
      'Tuesday' => 'Tu',
      'Wednesday' => 'W',
      'Thursday' => 'Th',
      'Friday' => 'F',
      'Saturday' => 'Sa',
      'Sunday' => 'Su'
    }.fetch(day)
  end
end
