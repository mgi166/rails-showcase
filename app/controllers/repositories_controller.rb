class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  def index
    @repository = Repository.page(params[:page])
  end

  def show
    @user = @repository.user
  end

  private

  def set_repository
    @repository = Repository.find(params[:id])
  end
end
