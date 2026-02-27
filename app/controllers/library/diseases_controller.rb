class Library::DiseasesController < Library::BaseLibraryController
  before_action :set_disease, only: %i[edit update]

  def index
    # システム提供
    @system_diseases =
      Disease
        .where(user_id: nil)
        .order(:id)

    # ユーザー作成
    @user_diseases =
      current_user.diseases
                  .order(updated_at: :desc)
  end

  def new
    @disease = Disease.new
  end

  def create
    @disease = current_user.diseases.build(disease_params)

    if @disease.save
      redirect_to library_diseases_path,
      notice: t("defaults.flash_message.created", item: Disease.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @disease.update(disease_params)
      redirect_to library_diseases_path, notice: "疾患を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_disease
    @disease = current_user.diseases.find_by!(slug: params[:id])
  end

  def disease_params
    params.require(:disease).permit(:name)
  end
end
