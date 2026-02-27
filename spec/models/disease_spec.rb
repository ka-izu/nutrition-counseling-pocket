require 'rails_helper'

RSpec.describe Disease, type: :model do
  describe "バリデーション" do
    it "nameがあれば有効であること" do
      disease = build(:disease)
      expect(disease).to be_valid
    end

    it "nameがなければ無効であること" do
      disease = build(:disease, name: nil)
      expect(disease).to be_invalid
      expect(disease.errors[:name]).to be_present
    end
  end

  describe "slug生成" do
    it "作成時にslugが自動生成されること" do
      disease = create(:disease, slug: nil)
      expect(disease.slug).to be_present
    end

    it "slugはユニークであること" do
      disease1 = create(:disease)
      disease2 = build(:disease)
      disease2.slug = disease1.slug
      expect(disease2).to be_invalid
      expect(disease2.errors[:slug]).to include("はすでに存在します")
    end
  end

  describe "#to_param" do
    it "slugを返すこと" do
      disease = create(:disease, slug: "abc123")
      expect(disease.to_param).to eq "abc123"
    end
  end

  describe "公開範囲スコープ(.available_for)" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:system_disease) { create(:disease, user_id: nil) }
    let!(:my_disease)     { create(:disease, user: user) }
    let!(:others_disease) { create(:disease, user: other_user) }

    subject { Disease.available_for(user) }

    it "システム提供データを含むこと" do
      expect(subject).to include(system_disease)
    end

    it "自分のデータを含むこと" do
      expect(subject).to include(my_disease)
    end

    it "他人のデータを含まないこと" do
      expect(subject).not_to include(others_disease)
    end
  end

  describe "#system_provided?" do
    context "user_idがnilの場合" do
      it "trueを返すこと（システム提供データ）" do
        disease = build(:disease, user_id: nil)

        expect(disease.system_provided?).to be true
      end
    end

    context "userが存在する場合" do
      it "falseを返すこと（ユーザー作成データ）" do
        user = create(:user)
        disease = build(:disease, user: user)

        expect(disease.system_provided?).to be false
      end
    end
  end
end
