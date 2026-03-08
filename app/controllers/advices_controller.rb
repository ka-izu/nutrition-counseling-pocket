class AdvicesController < ApplicationController
  def show
    @reply = params[:reply]
  end

  def create
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: "gpt-4.1-mini",
        messages: [
          { role: "user", content: "健康的な生活のためのアドバイスを一言ください" }
        ]
      }
    )

    reply = response.dig("choices", 0, "message", "content")

    redirect_to advice_path(reply: reply)
  end
end
