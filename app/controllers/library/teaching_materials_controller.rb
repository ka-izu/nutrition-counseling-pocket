class Library::TeachingMaterialsController < Library::BaseLibraryController
  def index
    @teaching_materials =
      current_user.teaching_materials
                  .joins(:diseases)
                  .where(diseases: { id: @disease.id })
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
    # TODO: save失敗後に取得でもOK?
    @diseases = Disease.where(user_id: [ nil, current_user.id ])

    if @teaching_material.save
      redirect_to library_disease_teaching_materials_path,
                  notice: "指導ツールを登録しました"
    else
      render :new, status: :unprocessable_entity, notice: "指導ツールを登録できませんでした"
    end
  end

  def edit
    @teaching_material =
      current_user.teaching_materials.find(params[:id])
    @diseases = Disease.where(user_id: [nil, current_user.id])
  end

  def update
    @teaching_material =
      current_user.teaching_materials.find(params[:id])

    if @teaching_material.update(teaching_material_params)
      redirect_to library_disease_teaching_materials_path,
                  notice: "指導ツールを更新しました"
    else
      @diseases = Disease.where(user_id: [nil, current_user.id])
      render :edit, status: :unprocessable_entity, notice: "指導ツールを更新できませんでした"
    end
  end

  private

  def teaching_material_params
    params.require(:teaching_material)
          .permit(:title, :description, disease_ids: [])
  end
end
