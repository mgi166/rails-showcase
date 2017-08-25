class RepositoriesController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_repository, only: [:show]

  def index
    @repositories = Repository.index(params)
  end

  def show
  end

  private

  def set_user
    @user = User.find_by(login: params[:user_login])
  end

  def set_repository
    @repository = @user.repositories.find_by!(name: params[:name]).decorate
  end
end
