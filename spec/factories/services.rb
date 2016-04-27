FactoryGirl.define do
  factory :service do
    name { Faker::Company.name }
    resource nil
  end
end
