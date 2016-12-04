FactoryGirl.define do
  factory :change_request do

    after :create do
      create(:field_change, field_name: 'name', field_value: Faker::Company.name)
      create(:field_change, field_name: 'long_description', field_value: Faker::ShelterTech.description)
    end
 
  end
end
