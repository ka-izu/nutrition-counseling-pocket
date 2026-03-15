require "rails_helper"

RSpec.describe AdviceGenerator do
  describe ".generate" do
    it "AIレスポンスからテキストを取得する" do
      fake_response = "テストアドバイス"

      client = instance_double(Openai::Client)

      allow(Openai::Client).to receive(:new).and_return(client)
      allow(client).to receive(:generate).and_return(fake_response)

      result = AdviceGenerator.generate(
        disease: "糖尿病",
        diet: [ "野菜が少ない" ],
        lifestyle: [ "運動習慣が少ない" ],
        personality: "これからやってみたい",
        patient_context: "75歳、独居"
      )

      expect(result).to eq("テストアドバイス")
    end
  end
end
