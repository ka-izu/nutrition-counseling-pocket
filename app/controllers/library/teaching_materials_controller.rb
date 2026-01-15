class Library::TeachingMaterialsController < Library::BaseLibraryController
  def index
    @teaching_materials =
      current_user.teaching_materials
                  .joins(:diseases)
                  .where(diseases: { id: @disease.id })
                  .order(created_at: :desc)
  end
end
