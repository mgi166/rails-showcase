class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  def index
    @repositories = Repository.order_by_stargazers.page(params[:page])
  end

  def show
    @user = @repository.user
  end

  private

  def set_repository
    @repository = Repository.find_by(name: params[:name])
  end
end
