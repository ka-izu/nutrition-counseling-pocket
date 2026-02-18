class Library::BaseLibraryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_disease

  private

  def set_disease
    return if params[:disease_id].blank?

    @disease =
      Disease
        .available_for(current_user)   # アクセス可能範囲をログインユーザーが閲覧できる範囲に制限
        .find_by!(slug: params[:disease_id])
  end
end
