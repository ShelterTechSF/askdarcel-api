# frozen_string_literal: true

module ShelterTech
  module Time
    ## Convert time from hhmm format to number of minutes since midnight
    def self.hhmm_to_minutes(time)
      (time / 100) * 60 + time % 60
    end

    ## Convert time from number of minutes since midnight to hhmm
    def self.minutes_to_hhmm(time)
      hours, minutes = time.divmod 60
      hours * 100 + minutes
    end
  end
end
