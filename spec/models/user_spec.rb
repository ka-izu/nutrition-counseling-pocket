require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    context "有効な場合" do
      it "全ての項目が入力されている場合、有効であること" do
        user = build(:user)
        expect(user).to be_invalid
      end

      it "nameが255文字の場合、有効であること" do
        user = build(:user, name: "a" * 255)
        expect(user).to be_valid
      end
    end

    context "無効な場合" do
      it "nameが未設定の場合、無効であること" do
        user = build(:user, name: nil)
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "nameが256文字の場合、無効であること" do
        user = build(:user, name: "a" * 256)
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("は255文字以内で入力してください")
      end
    end
  end
end
