class RepositoriesController < ApplicationController
  def index
    @repository = Repository.all
  end

  def show
  end
end
