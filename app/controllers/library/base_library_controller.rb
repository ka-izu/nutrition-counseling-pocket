class Library::BaseLibraryController < ApplicationController
  before_action :authenticate_user!
end
