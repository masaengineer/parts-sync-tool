FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
  end
end
