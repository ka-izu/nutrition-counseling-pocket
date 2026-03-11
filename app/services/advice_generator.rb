class AdviceGenerator
  def self.generate(disease:, diet:, lifestyle:, personality:)
    client = Openai::Client.new

    system_prompt = <<~TEXT
      あなたは管理栄養士を支援するアシスタントです。
      患者情報をもとに、管理栄養士が患者へ生活・栄養アドバイスを行う際のヒントを作成してください。

      【安全ルール】
      - 医療行為・診断・治療の指示は行わない
      - 不安を煽る表現は禁止
      - 数値や効果は断定しない（参考レベルにとどめる）

      【内容ルール】
      - 日常生活で無理なく続けられる「今日できる小さな一歩」を提案する
      - 一般論ではなく、患者情報に合わせた具体的な行動レベルの提案にする
      - 性格傾向に合わせて、負担が少ない内容に調整する
      - 専門用語は使わない

      【文章ルール】
      - 命令口調は禁止
      - 「〜してください」は使わない
      - 次のような提案表現を使う
        ・〜するだけでもOKです
        ・〜してみましょう

      【出力形式】
      - 2〜3文
      - 箇条書き禁止
      - 自然で人間らしい文章
      - 表現の繰り返しを避ける
    TEXT

    user_prompt = <<~TEXT
      以下の患者情報をもとに、栄養アドバイスのヒントを作成してください。

      【疾患】
      #{disease}

      【食生活】
      #{format_list(diet)}

      【生活習慣】
      #{format_list(lifestyle)}

      【食事療法に関する関心】
      #{personality}
    TEXT

    client.generate(
      system_prompt: system_prompt,
      user_prompt: user_prompt
    )
  end

  def self.format_list(value)
    Array(value).join("、")
  end
end
