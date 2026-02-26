require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "バリデーション" do
    it "name があれば有効であること" do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it "name が無いと無効であること" do
      tag = build(:tag, name: nil)
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end

    it "15文字以内なら有効であること" do
      tag = build(:tag, name: "あ" * 15)
      expect(tag).to be_valid
    end

    it "16文字以上は無効であること" do
      tag = build(:tag, name: "あ" * 16)
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end
  end

  describe "name の一意性" do
    let(:user) { create(:user) }

    it "同一ユーザー内で同名は無効であること" do
      create(:tag, user: user, name: "Ruby")

      tag = build(:tag, user: user, name: "Ruby")
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end

    it "別ユーザーなら同名でも有効であること" do
      create(:tag, user: user, name: "Ruby")

      other_user = create(:user)
      tag = build(:tag, user: other_user, name: "Ruby")

      expect(tag).to be_valid
    end
  end

  describe "関連付け" do
    it "user に属していること" do
      tag = create(:tag)
      expect(tag.user).to be_present
    end
  end
end
