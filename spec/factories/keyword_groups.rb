FactoryGirl.define do
  factory :keyword_group do
    keywords { Faker::Lorem.words(4) }
    exceptions { Faker::Lorem.words(4) }
  end
end
