class Library::KnowledgeMemosController < Library::BaseDiseaseController
  def index
    @knowledge_memos =
      @disease.knowledge_memos
              .includes(:user)
              .order(updated_at: :desc)
    @selected_memo = @knowledge_memos.first
  end

  def show
    @selected_memo = @disease.knowledge_memos.find(params[:id])

    render partial: "detail", locals: { memo: @selected_memo }
  end
end
