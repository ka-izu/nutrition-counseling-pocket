class AdvicesController < ApplicationController
  def show
  end

  def create
    client = OpenAI::Client.new

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

      【文体参考（内容は繰り返さない）】
      外食のときは、汁物の汁を少し残すだけでも塩分を減らせます。今日はそれだけ意識できれば十分です。
      忙しい日は、主食にゆで卵や納豆を足すだけでも栄養のバランスが整いやすくなります。無理のない範囲で試してみるだけでもOKです。
    TEXT

    user_prompt = <<~TEXT
      以下の患者情報をもとに、栄養アドバイスのヒントを作成してください。

      【疾患】
      #{params[:condition]}

      【食生活】
      #{params[:diet]}

      【生活習慣】
      #{params[:lifestyle]}

      【性格傾向】
      #{params[:personality]}
    TEXT

    begin
      response = client.responses.create(
        parameters: {
          model: "gpt-4.1-mini",
          input: [
            { role: "system", content: system_prompt },
            { role: "user", content: user_prompt }
          ],
          max_output_tokens: 120
        }
      )

      @result = response.dig("output", 0, "content", 0, "text") || "AIの回答が取得できませんでした"
    rescue StandardError => e
      Rails.logger.error "OpenAI Error: #{e.message}"
      @error = true
      @result ||= "AIの生成中にエラーが発生しました"
    end
  end
end
