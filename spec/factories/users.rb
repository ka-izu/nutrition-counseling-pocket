FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "ユーザー#{n}" }
    sequence(:email) { |n| "nc-pocket_#{n}@example.com" }
    password { "password123" }
  end
end
