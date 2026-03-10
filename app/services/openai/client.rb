require "openai"

module Openai
  class Client
    DEFAULT_MODEL = "gpt-4.1-mini"

    def initialize(model: DEFAULT_MODEL)
      @model = model
      @client = OpenAI::Client.new
    end

    def generate(system_prompt:, user_prompt:)
      response = @client.responses.create(
        parameters: {
          model: @model,
          input: [
            { role: "system", content: system_prompt },
            { role: "user", content: user_prompt }
          ],
          max_output_tokens: 120
        }
      )

      response.dig("output", 0, "content", 0, "text") || "AIの回答が取得できませんでした"
    end
  end
end
