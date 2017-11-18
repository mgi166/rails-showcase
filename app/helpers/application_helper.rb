module ApplicationHelper
  def github_repository_url(repository)
    URI.join('https://github.com', repository.name_with_owner).to_s
  end

  def tab_activated?(key)
    order = params[:order]

    if order.blank?
      key == 'stargazers_count'
    else
      order == key
    end
  end
end
