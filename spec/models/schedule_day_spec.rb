# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleDay, type: :model do
	describe "validate presence" do 
		it 'is not valid if opens_at is blank' do
			sd = ScheduleDay.new(day: "Monday", opens_at: nil, closes_at: 300)
			expect(sd).to_not be_valid
		end
		it 'is not valid if closes_at is blank' do
			sd = ScheduleDay.new(day: "Monday", opens_at: 700, closes_at: nil)
			expect(sd).to_not be_valid
		end
  		it 'is valid if closes_at and opens_at is present' do
  			sd = ScheduleDay.new(day: "Monday", opens_at: 700, closes_at: 300)
  			expect(sd).to be_valid
  		end
	end

end