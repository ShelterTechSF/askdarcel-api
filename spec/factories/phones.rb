FactoryGirl.define do
  factory :phone do
    number { Faker::PhoneNumber.phone_number }
    extension { Faker::PhoneNumber.extension }
    service_type "Business"
    country_code "001"
    resource nil
  end
end
