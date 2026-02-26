require "rails_helper"

RSpec.describe "Library::Diseases", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "POST /library/diseases" do
    context "未ログイン" do
      it "作成できずログイン画面へリダイレクト" do
        post library_diseases_path, params: { disease: { name: "糖尿病" } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before { sign_in user }

      it "疾患を作成できること" do
        expect {
          post library_diseases_path, params: { disease: { name: "糖尿病" } }
        }.to change(Disease, :count).by(1)


        disease = Disease.last
        expect(response).to have_http_status(:found)
        expect(disease.name).to eq("糖尿病")
        expect(disease.user).to eq(user)
      end
    end

    context "nameが空の場合" do
      before { sign_in user }

      it "作成できないこと" do
        expect {
          post library_diseases_path, params: { disease: { name: "" } }
        }.not_to change(Disease, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
