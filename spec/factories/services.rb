FactoryGirl.define do
  factory :service do
    name { Faker::Company.name }
    resource nil
    after :create do |service|
      create(:note, service: service)
      create(:schedule, service: service)
    end
  end
end
