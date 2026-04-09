require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /account/edit" do
    it "編集画面が表示される" do
      get edit_account_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /account" do
    context "正常系" do
      it "アカウントが更新される" do
        patch account_path, params: {
          user: { name: "新しい名前" }
        }

        expect(response).to redirect_to(account_path)
        expect(user.reload.name).to eq "新しい名前"
      end
    end

    context "異常系" do
      it "更新失敗時はeditが再表示される" do
        patch account_path, params: {
          user: { name: "" } # バリデーションNG想定
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /account" do
    it "アカウントが削除される" do
      expect {
        delete account_path
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "未ログイン時" do
    it "ログイン画面にリダイレクトされる" do
      sign_out user
      get edit_account_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
