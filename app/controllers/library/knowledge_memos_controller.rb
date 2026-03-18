class Library::KnowledgeMemosController < Library::BaseDiseaseController
  def index
    @knowledge_memos = [
      OpenStruct.new(
        id: 1,
        title: "糖尿病 食事指導の基本",
        content: "血糖値の急上昇を防ぐために、食物繊維を先に摂取することが重要。GI値の低い食品を選ぶよう指導する。",
        updated_at: Time.current
      ),
      OpenStruct.new(
        id: 2,
        title: "間食のコントロール",
        content: "間食は完全禁止ではなく、低GI食品（ナッツ・ヨーグルト）を推奨すると継続しやすい。",
        updated_at: Time.current - 1.day
      ),
      OpenStruct.new(
        id: 3,
        title: "外食時のアドバイス",
        content: "定食スタイルを選び、単品料理（ラーメン・丼）は避けるように指導。",
        updated_at: Time.current - 2.days
      )
    ]

    @selected_memo = @knowledge_memos.first
  end
end
