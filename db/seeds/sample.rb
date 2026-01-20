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

# TeachingMaterials のサンプル定義
materials_data = [
  {
    title: "食事療法の基本説明",
    description: "初回指導用資料"
  },
  {
    title: "外食時の注意点",
    description: "外食・コンビニ利用時のポイント"
  },
  {
    title: "よくある質問集",
    description: "患者さんからよく聞かれる質問まとめ"
  }
]

# システム疾患（マスタ）
system_diseases = Disease.where(user_id: nil)

materials = materials_data.map do |data|
  # 既存レコードを探す
  material =
    TeachingMaterial.find_by(
      title: data[:title],
      user: user
    )

  # なければ new
  unless material
    material = TeachingMaterial.new(
      title: data[:title],
      description: data[:description],
      user: user
    )
  end

  # ----------------------------
  # 疾患を先にセット（バリデーション対策）
  # ----------------------------
  diseases =
    case material.title
    when "食事療法の基本説明"
      system_diseases
    when "外食時の注意点"
      system_diseases.where(name: "糖尿病")
    when "よくある質問集"
      system_diseases.where(name: [ "糖尿病", "高血圧" ])
    else
      []
    end

  material.diseases = diseases

  # ----------------------------
  # sample.png を attach（未登録時のみ）
  # ----------------------------
  unless material.document.attached?
    file_path = Rails.root.join("db", "seeds", "sample.png")

    unless File.exist?(file_path)
      raise "seed image not found: #{file_path}"
    end

    material.document.attach(
      io: File.open(file_path),
      filename: "sample.png",
      content_type: "image/png"
    )
  end

  # 保存（既存なら UPDATE / 新規なら INSERT）
  material.save!

  material
end
