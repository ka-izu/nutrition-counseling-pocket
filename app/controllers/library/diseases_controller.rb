class Library::DiseasesController < Library::BaseLibraryController
  def index
    @diseases = Disease.where(user_id: [ nil, current_user.id ])
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

  def disease_params
    params.require(:disease).permit(:name)
  end
end
