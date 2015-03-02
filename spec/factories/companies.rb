FactoryGirl.define do
  factory :company do
    association :owner, factory: :user

    name { Faker::Company.name }
    phone { Faker::PhoneNumber.cell_phone }
    website { Faker::Internet.url }
    address { Faker::Address.city }
    details { Faker::Company.bs }
  end
end
