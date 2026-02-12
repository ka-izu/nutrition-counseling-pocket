FactoryBot.define do
  factory :disease do
    sequence(:name) { |n| "疾患#{n}" }
    slug { SecureRandom.hex(8) }

    association :user
  end
end
