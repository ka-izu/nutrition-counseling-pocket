require 'rails_helper'

RSpec.describe KnowledgeMemo, type: :model do
  describe "バリデーション" do
    it "titleがあれば有効であること" do
      memo = build(:knowledge_memo, title: "テスト")
      expect(memo).to be_valid
    end

    it "titleがなければ無効であること" do
      memo = build(:knowledge_memo, title: nil)
      expect(memo).not_to be_valid
      expect(memo.errors[:title]).to include("を入力してください")
    end
  end

  describe "アソシエーション" do
    it "diseaseに属すること" do
      memo = create(:knowledge_memo)
      expect(memo.disease).to be_present
    end

    it "userに属すること" do
      memo = create(:knowledge_memo)
      expect(memo.user).to be_present
    end
  end

  describe ".owned_by" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:own_memo1) { create(:knowledge_memo, user: user) }
    let!(:own_memo2) { create(:knowledge_memo, user: user) }
    let!(:other_memo) { create(:knowledge_memo, user: other_user) }

    it "指定したユーザーのメモのみ取得する" do
      result = KnowledgeMemo.owned_by(user)

      expect(result).to include(own_memo1, own_memo2)
      expect(result).not_to include(other_memo)
    end
  end
end
