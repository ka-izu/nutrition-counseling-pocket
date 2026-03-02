class Library::TeachingMaterialsController < Library::BaseLibraryController
  before_action :set_disease

  def index
    @q =
      current_user.teaching_materials
                  .joins(:diseases)
                  .ransack(params[:q])

    @teaching_materials =
      @q.result(distinct: true)
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

  def autocomplete
        @teaching_materials =
            current_user.teaching_materials
              .joins(:teaching_material_diseases)
              .where(teaching_material_diseases: { disease_id: @disease.id })
              .where("teaching_materials.title LIKE ?", "%#{params[:q]}%")
              .select("DISTINCT teaching_materials.title")
              .order("teaching_materials.title")
              .limit(10)

    respond_to do |format|
      format.js
    end
  end

  private

  def teaching_material_params
    params.require(:teaching_material)
          .permit(:title, :description, :document, :tag_names, disease_ids: [])
  end

  def set_disease
    return if params[:disease_id].blank?

    @disease =
      Disease
        .available_for(current_user)   # アクセス可能範囲をログインユーザーが閲覧できる範囲に制限
        .find_by!(slug: params[:disease_id])
  end
end
