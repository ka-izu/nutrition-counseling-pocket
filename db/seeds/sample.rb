# サンプルデータ
# ----------------------------

# サンプル用ユーザー
user =
  User.find_or_create_by!(
    email: "t.test@example.com"
  ) do |u|
    u.password = "p@ssword"
    u.name     = "テストユーザー"
  end

# # ----------------------------
# # TeachingMaterials のサンプル定義
# # ----------------------------
# materials_data = [
#   {
#     title: "食事療法の基本説明",
#     description: "初回指導用資料"
#   },
#   {
#     title: "外食時の注意点",
#     description: "外食・コンビニ利用時のポイント"
#   },
#   {
#     title: "よくある質問集",
#     description: "患者さんからよく聞かれる質問まとめ"
#   }
# ]

# # システム疾患（マスタ）
# system_diseases = Disease.where(user_id: nil)

# materials = materials_data.map do |data|
#   # 既存レコードを探す
#   material =
#     TeachingMaterial.find_by(
#       title: data[:title],
#       user: user
#     )

#   # なければ new
#   unless material
#     material = TeachingMaterial.new(
#       title: data[:title],
#       description: data[:description],
#       user: user
#     )
#   end

#   # ----------------------------
#   # 疾患を先にセット（バリデーション対策）
#   # ----------------------------
#   diseases =
#     case material.title
#     when "食事療法の基本説明"
#       system_diseases
#     when "外食時の注意点"
#       system_diseases.where(name: "糖尿病")
#     when "よくある質問集"
#       system_diseases.where(name: [ "糖尿病", "高血圧" ])
#     else
#       []
#     end

#   material.diseases = diseases

#   # ----------------------------
#   # sample.png を attach（未登録時のみ）
#   # ----------------------------
#   unless material.document.attached?
#     file_path = Rails.root.join("db", "seeds", "sample.png")

#     unless File.exist?(file_path)
#       raise "seed image not found: #{file_path}"
#     end

#     material.document.attach(
#       io: File.open(file_path),
#       filename: "sample.png",
#       content_type: "image/png"
#     )
#   end

#   # 保存（既存なら UPDATE / 新規なら INSERT）
#   material.save!

#   material
# end

# ----------------------------
# KnowledgeMemo のサンプル定義
# ----------------------------
memos_data = [
  {
    title: "血糖コントロールの基本",
    content: "食物繊維を先に摂取することで血糖値の急上昇を防ぐ。GI値の低い食品を選ぶ。",
    disease_names: [ "糖尿病" ]
  },
  {
    title: "減塩のポイント",
    content: "加工食品を控え、出汁や香辛料を活用して塩分を抑える。",
    disease_names: [ "高血圧" ]
  },
  {
    title: "間食のコントロール",
    content: "ナッツやヨーグルトなど低GIの食品を選択することで血糖値の安定につながる。",
    disease_names: [ "糖尿病" ]
  }
]

system_diseases = Disease.where(user_id: nil)

memos_data.each do |data|
  diseases = system_diseases.where(name: data[:disease_names])

  diseases.each do |disease|
    memo =
      KnowledgeMemo.find_or_initialize_by(
        title: data[:title],
        disease: disease,
        user: user
      )

    memo.content = data[:content]

    memo.save!
  end
end
