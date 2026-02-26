require "rails_helper"

RSpec.describe TeachingMaterial, type: :model do
  describe "tag_names によるタグ割り当て" do
    let(:user) { create(:user) }

    context "新規タグを入力した場合" do
      it "Tagが新しく作成されること" do
        material = build(:teaching_material, :with_pdf, user: user)
        material.tag_names = "Ruby, Rails"

        expect {
          material.save!
        }.to change { Tag.count }.by(2)

        expect(material.tags.pluck(:name)).to contain_exactly("Ruby", "Rails")
      end
    end

    context "既存タグがある場合" do
      before do
        create(:tag, user: user, name: "Ruby")
      end

      it "既存Tagを再利用し、重複作成しないこと" do
        material = build(:teaching_material, :with_pdf, user: user)
        material.tag_names = "Ruby"

        expect {
          material.save!
        }.not_to change { Tag.count }

        expect(material.tags.first.name).to eq("Ruby")
      end
    end

    context "別ユーザーの同名タグがある場合" do
      let!(:other_user) { create(:user) }
      let!(:other_tag)  { create(:tag, user: other_user, name: "Ruby") }

      it "自分のユーザーのTagとして新規作成すること" do
        material = build(:teaching_material, :with_pdf, user: user)
        material.tag_names = "Ruby"

        expect {
          material.save!
        }.to change { Tag.where(user: user, name: "Ruby").count }.by(1)
        .and change { Tag.where(user: other_user, name: "Ruby").count }.by(0)

        expect(material.tags.first).to have_attributes(
          name: "Ruby",
          user_id: user.id
        )
      end
    end

    context "空文字の場合" do
      it "Tagを作成しない" do
        material = build(:teaching_material, :with_pdf, user: user)
        material.tag_names = ""

        expect {
          material.save!
        }.not_to change { Tag.count }
      end
    end
  end
end
