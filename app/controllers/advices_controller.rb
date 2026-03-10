class AdvicesController < ApplicationController
  def show
  end

  def create
    @result = AdviceGenerator.generate(
      condition: params[:condition],
      diet: params[:diet],
      lifestyle: params[:lifestyle],
      personality: params[:personality]
    )

  rescue StandardError => e
    Rails.logger.error "Advice generation error: #{e.message}"
    @error = true
    @result = "AIの生成中にエラーが発生しました"
  end
end
