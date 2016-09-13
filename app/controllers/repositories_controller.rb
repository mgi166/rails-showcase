class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  def index
    @repository = Repository.all
  end

  def show
  end

  private

  def set_repository
    @repository = Repository.find(params[:id])
  end
end
