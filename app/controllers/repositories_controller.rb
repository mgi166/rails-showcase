class RepositoriesController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_repository, only: [:show]

  def index
    if params[:full_name]
      @repositories = Repository.with_like_full_name(params[:full_name]).includes(:user).page(params[:page])
    else
      @repositories = Repository.order_by_stargazers.includes(:user).page(params[:page])
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find_by(login: params[:user_login])
  end

  def set_repository
    @repository = @user.repositories.find_by(name: params[:name])
  end
end
