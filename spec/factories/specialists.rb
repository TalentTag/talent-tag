FactoryGirl.define do
  factory :specialist do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.free_email }

    password { Faker::Internet.password(8) }
    password_confirmation { password }

    can_login true
  end
end
