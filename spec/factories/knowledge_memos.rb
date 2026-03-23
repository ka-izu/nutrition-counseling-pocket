FactoryBot.define do
  factory :knowledge_memo do
    sequence(:title) { |n| "タイトル#{n}" }
    sequence(:content) { |n| "コンテンツ#{n}" }
    association :user
    association :disease
  end
end
