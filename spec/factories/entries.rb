FactoryGirl.define do
  factory :entry do
    association :user, factory: :specialist

    sequence(:id) { |n| n }
    body { Faker::Lorem.sentence }

    created_at { Faker::Date.backward }
    fetched_at { Faker::Date.backward }
  end
end
