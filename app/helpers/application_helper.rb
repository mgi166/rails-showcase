module ApplicationHelper
  def github_repository_url(repository)
    URI.join('https://github.com', repository.name_with_owner).to_s
  end
end
