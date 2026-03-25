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

  describe "POST /library/diseases/:disease_id/knowledge_memos" do
    before do
      sign_in user
    end

    context "正常系" do
      let(:valid_params) do
        {
          knowledge_memo: {
            title: "テストメモ",
            content: "内容"
          }
        }
      end

      it "メモが作成されること" do
        expect {
          post library_disease_knowledge_memos_path(disease), params: valid_params
        }.to change(KnowledgeMemo, :count).by(1)
      end

      it "userとdiseaseが紐づくこと" do
        post library_disease_knowledge_memos_path(disease), params: valid_params
        memo = KnowledgeMemo.last

        expect(memo.user).to eq(user)
        expect(memo.disease).to eq(disease)
      end

      it "一覧画面へリダイレクトされること" do
        post library_disease_knowledge_memos_path(disease), params: valid_params

        expect(response).to redirect_to(
          library_disease_knowledge_memos_path(disease)
        )
      end
    end

    context "異常系" do
      let(:invalid_params) do
        {
          knowledge_memo: {
            title: "",
            content: "内容"
          }
        }
      end

      it "メモが作成されないこと" do
        expect {
          post library_disease_knowledge_memos_path(disease), params: invalid_params
        }.not_to change(KnowledgeMemo, :count)
      end

      it "newページが再表示されること" do
        post library_disease_knowledge_memos_path(disease), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /library/diseases/:disease_id/knowledge_memos/:id" do
    let!(:memo) { create(:knowledge_memo, user: user, disease: disease, title: "旧タイトル") }

    before do
      sign_in user
    end

    context "正常系" do
      let(:valid_params) do
        {
          knowledge_memo: {
            title: "新タイトル",
            content: "更新内容"
          }
        }
      end

      it "メモが更新されること" do
        patch library_disease_knowledge_memo_path(disease, memo), params: valid_params

        expect(memo.reload.title).to eq("新タイトル")
        expect(memo.content).to eq("更新内容")
      end

      it "一覧画面へリダイレクトされること" do
        patch library_disease_knowledge_memo_path(disease, memo), params: valid_params

        expect(response).to redirect_to(
          library_disease_knowledge_memos_path(disease, memo_id: memo.id)
        )
      end
    end

    context "異常系" do
      let(:invalid_params) do
        {
          knowledge_memo: {
            title: "",
            content: "更新内容"
          }
        }
      end

      it "メモが更新されないこと" do
        patch library_disease_knowledge_memo_path(disease, memo), params: invalid_params

        expect(memo.reload.title).to eq("旧タイトル")
      end

      it "editページが再表示されること" do
        patch library_disease_knowledge_memo_path(disease, memo), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "権限系" do
      let(:other_user) { create(:user) }
      let!(:other_memo) { create(:knowledge_memo, user: other_user, disease: disease) }

      it "他ユーザーのメモは更新できないこと" do
        patch library_disease_knowledge_memo_path(disease, other_memo), params: {
          knowledge_memo: { title: "不正更新" }
        }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
