module ApplicationHelper
  def github_repository_url(repository)
    URI.join('https://github.com', repository.full_name).to_s
  end
end
