# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# System Diseases の初期データ
system_disease_names = [
  "糖尿病",
  "高血圧",
  "脂質異常症",
  "慢性腎臓病",
  "痛風・高尿酸血症"
]

system_diseases = system_disease_names.map do |name|
  Disease.find_or_create_by!(name: name, user_id: nil)
end

# ========================
# 以下は動作確認用サンプルデータ
# ========================

# TeachingMaterials のサンプルデータ
user = User.first || User.create!(
  email: "t.test@example.com",
  password: "p@ssword",
  name: "テストユーザー"
)

materials = TeachingMaterial.create!([
  {
    title: "食事療法の基本説明",
    description: "初回指導用資料",
    user: user
  },
  {
    title: "外食時の注意点",
    description: "外食・コンビニ利用時のポイント",
    user: user
  },
  {
    title: "よくある質問集",
    description: "患者さんからよく聞かれる質問まとめ",
    user: user
  }
])

# TeachingMaterialsDiseases のサンプルデータ
materials.each do |material|
  case material.title
  when "食事療法の基本説明"
    material.diseases << system_diseases

  when "外食時の注意点"
    material.diseases << [
      system_diseases[0]
    ]

  when "よくある質問集"
    material.diseases << [
      system_diseases[0],
      system_diseases[1]
    ]
  end
end
