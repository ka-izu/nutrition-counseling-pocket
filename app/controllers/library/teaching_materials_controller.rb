class Library::TeachingMaterialsController < Library::BaseLibraryController
  def index
    # 検索条件用のベースクエリ
    # 疾患で絞り込むために JOIN を使う（ここでは表示用の関連は考えない）
    base =
      current_user.teaching_materials
                  .joins(:diseases)
                  .where(diseases: { id: @disease.id })

    # Ransack による検索条件の適用
    # JOIN済みの Relation に対して検索条件を追加する
    @q = base.ransack(params[:q])

    # 表示用のクエリ
    # 疾患での絞り込みは検索用に限定し、
    # 表示用には教材を改めて取得して関連を正しく読み込む
    @teaching_materials =
      TeachingMaterial
        .where(id: @q.result.select(:id))
        .includes(
          :diseases,
          document_attachment: :blob
        )
        .order(created_at: :desc)
  end

  def new
    @teaching_material = TeachingMaterial.new

    # 一覧ページで選択した疾患を @teaching_material.diseases の初期値としてセット
    if @disease
      @teaching_material.diseases << @disease
    end

    # user-generated + system-generated 疾患を取得
    @diseases = Disease.where(user_id: [ nil, current_user.id ])
  end

  def create
    @teaching_material =
      current_user.teaching_materials.build(teaching_material_params)

    if @teaching_material.save
      redirect_to library_disease_teaching_materials_path,
      notice: t("defaults.flash_message.created", item: TeachingMaterial.model_name.human)
    else
      @diseases = Disease.where(user_id: [ nil, current_user.id ])
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @teaching_material =
      current_user.teaching_materials.find(params[:id])
    @diseases = Disease.where(user_id: [ nil, current_user.id ])
  end

  def update
    @teaching_material =
      current_user.teaching_materials.find(params[:id])

    if @teaching_material.update(teaching_material_params)
      redirect_to library_disease_teaching_materials_path,
                  notice: t("defaults.flash_message.updated", item: TeachingMaterial.model_name.human)
    else
      @diseases = Disease.where(user_id: [ nil, current_user.id ])
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @teaching_material =
      current_user.teaching_materials.find(params[:id])

    @teaching_material.destroy

    redirect_to library_disease_teaching_materials_path,
                status: :see_other,
                notice: t("defaults.flash_message.deleted", item: TeachingMaterial.model_name.human)
  end

  private

  def teaching_material_params
    params.require(:teaching_material)
          .permit(:title, :description, :document, disease_ids: [])
  end
end
