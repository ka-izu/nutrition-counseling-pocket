FactoryBot.define do
  factory :teaching_material do
    sequence(:title) { |n| "指導ツール#{n}" }
    sequence(:description) { |n| "説明#{n}" }

    association :user

    # 疾患必須バリデーションを満たす
    after(:build) do |material|
      material.diseases << build(:disease, user: material.user)
    end

    # trait
    # --- 添付ファイル関連 ---
    # PDFファイル をアタッチ
    trait :with_pdf do
      after(:build) do |material|
        material.document.attach(
          io: Rails.root.join("spec/fixtures/files/sample.pdf").open,
          filename: "sample.pdf",
          content_type: "application/pdf"
        )
      end
    end

    # 画像ファイル（.png）をアタッチ
    trait :with_image_file do
      after(:build) do |material|
        material.document.attach(
          io: Rails.root.join("spec/fixtures/files/sample.png").open,
          filename: "sample.png",
          content_type: "image/png"
        )
      end
    end

    # 許可されていないファイル形式（.txt）をアタッチ
    trait :with_invalid_file do
      after(:build) do |material|
        material.document.attach(
          io: Rails.root.join("spec/fixtures/files/sample.txt").open,
          filename: "sample.txt",
          content_type: "text/plain"
        )
      end
    end

    # 5.1MBのファイル（バリデーションでは 5MB 以下を許可）をアタッチ
    trait :with_large_pdf do
      after(:build) do |material|
        material.document.attach(
          io: Rails.root.join("spec/fixtures/files/large.pdf").open,
          filename: "large.pdf",
          content_type: "application/pdf"
        )
      end
    end

    # ファイル未添付
    trait :without_document do
      after(:build) { |material| material.document.detach }
    end
    # -----

    # --- 疾患紐付け関連 ---
    # disease紐付け
    trait :with_disease do
      transient do
        disease { build(:disease) }
      end

      after(:create) do |material, evaluator|
        material.diseases << evaluator.disease
      end
    end

    # disease無し
    trait :without_diseases do
      after(:build) { |material| material.diseases = [] }
    end
    # -----
  end
end
