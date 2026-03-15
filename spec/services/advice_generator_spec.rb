require "rails_helper"

RSpec.describe AdviceGenerator do
  describe ".generate" do
    it "プロンプトを生成する" do
      result = AdviceGenerator.generate(
        disease: "糖尿病",
        diet: [ "野菜が少ない" ],
        lifestyle: [ "運動習慣が少ない" ],
        personality: "これからやってみたい",
        patient_context: "75歳、独居"
      )

      expect(result).to be_present
    end
  end
end
