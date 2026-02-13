require 'rails_helper'

RSpec.describe TeachingMaterial, type: :model do
  describe "バリデーションチェック" do
    it "指導ツールを作成できること" do
      teaching_material = build(:teaching_material)
      expect(teaching_material).to be_valid
    end

    it "disease が1件以上紐付いていること" do
      teaching_material = build(:teaching_material, :without_diseases)
      expect(teaching_material).to be_invalid
      expect(teaching_material.errors[:teaching_material_diseases]).to include("を選択してください")
    end

    it "ファイルが添付されていない場合は無効であること" do
      teaching_material = build(:teaching_material, :without_document)
      expect(teaching_material).to be_invalid
      expect(teaching_material.errors[:document]).to include("を選択してください")
    end
  end

  describe "ファイルのバリデーション" do
    it "許可されているファイル形式は有効であること" do
      expect(build(:teaching_material, :with_image_file)).to be_valid
    end

    it "許可されていないファイル形式は無効であること" do
      expect(build(:teaching_material, :with_invalid_file)).to be_invalid
    end

    it "5.1MBのファイルは無効であること" do
      material = build(:teaching_material, :with_large_pdf)
      expect(material).to be_invalid
    end
  end

  describe "#thumbnail" do
    context "document が未添付の場合" do
      it "nil を返す" do
        teaching_material = build(:teaching_material, :without_document)
        expect(teaching_material.thumbnail).to be_nil
      end
    end

    context "画像の場合" do
      it "variant を返す" do
        teaching_material = build(:teaching_material, :with_image_file)
        expect(teaching_material.thumbnail).to be_present
      end
    end

    context "PDFの場合" do
      it "preview を返す" do
        teaching_material = build(:teaching_material)
        expect(teaching_material.thumbnail).to be_present
      end
    end
  end

  describe "#thumbnail?" do
    it "表示可能な場合 true" do
      teaching_material = build(:teaching_material, :with_image_file)
      expect(teaching_material.thumbnail?).to be true
    end

    it "未添付なら false" do
      teaching_material = build(:teaching_material, :without_document)
      expect(teaching_material.thumbnail?).to be false
    end
  end

  describe "#pdf?" do
    it "PDFなら true" do
      teaching_material = build(:teaching_material)
      expect(teaching_material.pdf?).to be true
    end

    it "画像なら false" do
      teaching_material = build(:teaching_material, :with_image_file)
      expect(teaching_material.pdf?).to be false
    end
  end

  describe ".ransackable_attributes" do
    it "検索可能属性が制限されていること" do
      expect(TeachingMaterial.ransackable_attributes).to match_array(%w[title description])
    end
  end

  describe ".ransackable_associations" do
    it "関連検索は許可していないこと" do
      expect(TeachingMaterial.ransackable_associations).to eq([])
    end
  end
end
