require 'rails_helper'

RSpec.describe "Library::KnowledgeMemos", type: :request do
  let(:user) { create(:user) }
  let(:disease) { create(:disease, user: user) }

  describe "GET /library/diseases/:disease_id/knowledge_memos" do
    context "未ログイン" do
      it "ログイン画面へリダイレクトされること" do
        get library_disease_knowledge_memos_path(disease)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before do
        sign_in user
      end

      it "一覧を取得できること" do
        create_list(:knowledge_memo, 3, user: user, disease: disease)

        get library_disease_knowledge_memos_path(disease)

        expect(response).to have_http_status(:ok)
      end

      it "メモが表示されること" do
        memo = create(:knowledge_memo, title: "テスト", user: user, disease: disease)

        get library_disease_knowledge_memos_path(disease)

        expect(response.body).to include("テスト")
      end

      it "他ユーザーのメモは表示されないこと" do
        other_user = create(:user)
        create(:knowledge_memo, title: "他人のメモ", user: other_user, disease: disease)
        own_memo = create(:knowledge_memo, title: "自分のメモ", user: user, disease: disease)

        get library_disease_knowledge_memos_path(disease)

        expect(response.body).not_to include("他人のメモ")
        expect(response.body).to include("自分のメモ")
      end
    end
  end
end
