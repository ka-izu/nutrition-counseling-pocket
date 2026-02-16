require 'rails_helper'

RSpec.describe "User Registrations", type: :request do
  describe "POST /users" do
    context "正常系" do
      it "ユーザー登録できること" do
        user_params = attributes_for(:user)

        expect {
          post user_registration_path, params: {
            user: user_params.merge(
              password_confirmation: user_params[:password]
            )
          }
        }.to change(User, :count).by(1)

        # サインアップに成功した場合、トップページへリダイレクト
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_path)
      end
    end

    context "異常系" do
      it "不正な入力では登録できないこと" do
        user_params = attributes_for(:user, email: "")

        expect {
          post user_registration_path, params: {
            user: user_params.merge(
              password_confirmation: user_params[:password]
            )
          }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
