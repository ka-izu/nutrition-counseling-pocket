require 'rails_helper'

RSpec.describe "Library::TeachingMaterials", type: :request do
  let(:user) { create(:user) }
  let(:disease) { create(:disease, user: user) }
  let(:file) do
    fixture_file_upload(
      Rails.root.join("spec/fixtures/files/sample.pdf"),
      "application/pdf"
    )
  end

  describe "GET /library/diseases/:disease_id/teaching_materials" do
    context "未ログイン" do
      it "ログイン画面へリダイレクトされること" do
        get library_disease_teaching_materials_path(disease)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before do
        sign_in user
      end

      it "一覧を取得できること" do
        create_list(:teaching_material, 3, :with_pdf, user: user, diseases: [ disease ])

        get library_disease_teaching_materials_path(disease)

        expect(response).to have_http_status(:ok)
      end
    end

    context "他ユーザーの疾患を指定した場合" do
      let(:other_user) { create(:user) }
      let(:other_disease) { create(:disease, user: other_user) }

      before do
        sign_in user
      end

      it "404になること" do
        get library_disease_teaching_materials_path(other_disease)

        expect(response).to have_http_status(:not_found)
      end
    end

    context "指導ツール検索" do
      before do
        sign_in user
      end

      it "検索パラメータを受け取れること" do
        get library_disease_teaching_materials_path(disease),
          params: { q: { title_or_description_cont: "糖尿病" } }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /library/diseases/:disease_id/teaching_materials" do
    context "未ログイン" do
      it "作成できずログイン画面へリダイレクト" do
        post library_disease_teaching_materials_path(disease),
             params: { teaching_material: attributes_for(:teaching_material) }

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before do
        sign_in user
      end

      it "自分の指導媒体を作成できること" do
        teaching_material_params = attributes_for(:teaching_material).merge(
          document: file,
          disease_ids: [ disease.id ]
        )

        expect {
          post library_disease_teaching_materials_path(disease),
               params: { teaching_material: teaching_material_params }
        }.to change(TeachingMaterial, :count).by(1)

        expect(response).to redirect_to(library_disease_teaching_materials_path(disease))
      end
    end
  end

  describe "PATCH /library/diseases/:disease_id/teaching_materials/:id" do
    context "自分の指導ツールの場合" do
      let(:material) { create(:teaching_material, :with_pdf, user: user, diseases: [ disease ]) }

      before do
        sign_in user
      end

      it "編集できること" do
        patch library_disease_teaching_material_path(disease, material), params: {
          teaching_material: { title: "編集後タイトル" }
        }

        expect(response).to redirect_to(library_disease_teaching_materials_path(disease))
        expect(material.reload.title).to eq("編集後タイトル")
      end
    end

    context "他ユーザーの疾患を指定した場合" do
      let(:other_user) { create(:user) }
      let(:other_disease) { create(:disease, user: other_user) }
      let(:material) do
        create(:teaching_material, :with_pdf, user: other_user).tap do |m|
          m.diseases = [ other_disease ]
        end
      end

      before do
        sign_in user
      end

      it "編集できないこと" do
        patch library_disease_teaching_material_path(other_disease, material), params: {
          teaching_material: { title: "編集" }
        }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /library/diseases/:disease_id/teaching_materials/:id" do
    let!(:material) { create(:teaching_material, :with_pdf, user: user, diseases: [ disease ]) }

    before do
      sign_in user
    end

    it "削除できること" do
      expect {
        delete library_disease_teaching_material_path(disease, material)
      }.to change(TeachingMaterial, :count).by(-1)
    end
  end
end
