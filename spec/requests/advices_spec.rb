require 'rails_helper'

RSpec.describe "Advices", type: :request do
  describe "POST /advices" do
    it "パラメータが正しく渡される" do
      allow(AdviceGenerator).to receive(:generate).and_return("テストアドバイス")

      post advice_path,
        params: {
          disease: "糖尿病、高血圧",
          diet: [ "野菜が少ない" ],
          lifestyle: [ "運動習慣が少ない" ],
          personality: "これからやってみたい",
          patient_context: "75歳、独居"
        },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(AdviceGenerator).to have_received(:generate).with(
        hash_including(
          disease: "糖尿病、高血圧",
          diet: [ "野菜が少ない" ],
          lifestyle: [ "運動習慣が少ない" ],
          personality: "これからやってみたい",
          patient_context: "75歳、独居"
        )
      )
    end

    it "AIアドバイスを生成できる" do
      allow(AdviceGenerator).to receive(:generate)
        .and_return("テストアドバイス")

      post advice_path,
        params: {
          disease: "糖尿病",
          diet: [ "野菜が少ない" ],
          lifestyle: [ "運動習慣が少ない" ],
          personality: "これからやってみたい",
          patient_context: "75歳、独居"
        },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("turbo-stream")
      expect(response.body).to include("テストアドバイス")
    end

  it "disease と disease_other を結合する" do
    allow(AdviceGenerator).to receive(:generate)

    post advice_path, params: {
      disease: "糖尿病",
      disease_other: "高血圧"
    }

    expect(AdviceGenerator).to have_received(:generate).with(
      hash_including(
        disease: "糖尿病、高血圧"
      )
    )
  end

    it "disease_other は50文字で制限される" do
      allow(AdviceGenerator).to receive(:generate)

      long_text = "あ" * 51

      post advice_path, params: {
        disease_other: long_text
      },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(AdviceGenerator).to have_received(:generate).with(
        hash_including(
          disease: "あ" * 50
        )
      )
    end

    it "patient_context は200文字で制限される" do
      allow(AdviceGenerator).to receive(:generate)

      long_text = "あ" * 201

      post advice_path, params: {
        patient_context: long_text
      }

      expect(AdviceGenerator).to have_received(:generate).with(
        hash_including(
          patient_context: "あ" * 200
        )
      )
    end

    it "AIエラー時にエラーメッセージを表示する" do
      allow(AdviceGenerator).to receive(:generate)
        .and_raise(StandardError)

        post advice_path,
          params: {
            disease: "糖尿病",
            diet: [ "野菜が少ない" ],
            lifestyle: [ "運動習慣が少ない" ],
            personality: "これからやってみたい",
            patient_context: "75歳、独居"
          },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response.body).to include("AIの生成中にエラーが発生しました")
    end
  end
end
