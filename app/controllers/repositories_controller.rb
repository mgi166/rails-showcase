class RepositoriesController < ApplicationController
  def index
    @repository = Repository.all
  end
end
