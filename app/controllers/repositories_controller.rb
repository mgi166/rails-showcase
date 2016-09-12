class RepositoriesController < ApplicationController
  before_action :set_repository

  def index
    @repository = Repository.all
  end

  def show
  end

  def set_repository
    @repository = Repository.find(params[:id])
  end
end
