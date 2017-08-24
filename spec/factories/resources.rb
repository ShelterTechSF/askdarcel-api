FactoryGirl.define do
  factory :resource do
    name { Faker::Company.name }
    status 1
    after :create do |resource|
      create(:address, resource: resource)
      create(:phone, resource: resource)
      create(:schedule, resource: resource)
      create(:note, resource: resource)
    end
  end
end
