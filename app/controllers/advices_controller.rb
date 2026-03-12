class AdvicesController < ApplicationController
  def show
  end

  def create
    patient_context =
      params[:patient_context]
      .to_s
      .squish
      .truncate(200)

    @result = AdviceGenerator.generate(
      disease: params[:disease],
      diet: params[:diet],
      lifestyle: params[:lifestyle],
      personality: params[:personality],
      patient_context: patient_context
    )

  rescue StandardError => e
    Rails.logger.error "Advice generation error: #{e.message}"
    @error = true
    @result = "AIの生成中にエラーが発生しました"
  end
end
