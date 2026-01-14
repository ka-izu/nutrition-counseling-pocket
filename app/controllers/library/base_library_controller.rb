class Library::BaseLibraryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_disease

  private

  def set_disease
    return if params[:disease_id].blank?

    @disease = Disease.find_by!(slug: params[:disease_id])
  end
end
