class Library::DiseasesController < Library::BaseLibraryController
  def index
    @diseases = Disease.where(user_id: [ nil, current_user.id ])
  end
end
