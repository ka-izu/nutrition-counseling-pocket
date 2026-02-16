require 'rails_helper'

RSpec.describe "User Sessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    context "正常系" do
      it "ログインできること" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }

        expect(response).to have_http_status(:see_other)
      end
    end

    context "異常系" do
      it "間違った情報ではログインできないこと" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "wrong_password"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "ログアウト後は保護ページにアクセスできないこと" do
      # ログイン
      sign_in user

      # ログアウト
      delete destroy_user_session_path

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(root_path)

      # 疾患一覧ページへアクセス（認証が必要なページ）
      get library_diseases_path

      # ログイン画面へリダイレクトされることを確認
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
