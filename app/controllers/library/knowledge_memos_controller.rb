class Library::KnowledgeMemosController < Library::BaseDiseaseController
  def index
    @knowledge_memos =
      @disease.knowledge_memos
              .includes(:user)
              .order(updated_at: :desc)
    @selected_memo = @knowledge_memos.first
  end

  def new
    @knowledge_memo = KnowledgeMemo.new
  end

  def create
    @knowledge_memo =
      current_user.knowledge_memos.build(knowledge_memo_params)

    @knowledge_memo.disease = @disease

    if @knowledge_memo.save
      redirect_to library_disease_knowledge_memos_path,
      notice: t("defaults.flash_message.created", item: KnowledgeMemo.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @selected_memo = @disease.knowledge_memos.find(params[:id])

    render partial: "detail", locals: { memo: @selected_memo }
  end

  private

  def knowledge_memo_params
    params.require(:knowledge_memo).permit(:title, :content)
  end
end
