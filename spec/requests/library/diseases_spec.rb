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

  describe "PATCH /library/diseases/:id" do
    let(:user)        { create(:user) }
    let(:other_user)  { create(:user) }

    let!(:my_disease)     { create(:disease, user: user, name: "変更前") }
    let!(:others_disease) { create(:disease, user: other_user) }
    let!(:system_disease) { create(:disease, user_id: nil) }

    context "未ログイン" do
      it "ログイン画面へリダイレクトされること" do
        patch library_disease_path(my_disease), params: { disease: { name: "変更後" } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before { sign_in user }

      it "自分の疾患は更新できること" do
        patch library_disease_path(my_disease), params: { disease: { name: "変更後" } }

        expect(response).to have_http_status(:found)
        expect(my_disease.reload.name).to eq("変更後")
      end

      it "他人の疾患は更新できないこと" do
        patch library_disease_path(others_disease), params: { disease: { name: "不正変更" } }
        expect(response).to have_http_status(:not_found)
      end

      it "システム提供疾患は更新できないこと" do
        patch library_disease_path(system_disease), params: { disease: { name: "変更不可" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /library/diseases/:id" do
    context "ログイン済み" do
      before { sign_in user }

      let!(:disease) { create(:disease, user: user) }

      it "自分の疾患を削除できること" do
        expect {
          delete library_disease_path(disease)
        }.to change(Disease, :count).by(-1)

        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(library_diseases_path)
      end
    end
  end
end
