# frozen_string_literal: true

FactoryGirl.define do
  factory :phone do
    number do
      # There is a 0.5% chance that Faker will generate an invalid number, so
      # make multiple attempts.
      num = nil
      while num.nil? || num.invalid?
        # Faker formats extensions with 'x', but Phonelib expects ';'
        num = Phonelib.parse(Faker::PhoneNumber.phone_number.tr('x', ';'), 'US')
      end
      num.full_e164
    end
    service_type "Business"
    resource nil
  end
end
