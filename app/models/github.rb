class Github
  attr_reader :client

  REPOSITORY_ATTRIBUTES = %i(
    name
    full_name
    description
    html_url
    stargazers_count
    forks_count
  )

  USER_ATTRIBUTES = %i(
    login
    html_url
    avatar_url
  )

  def initialize
    @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def import
    each_repositories do |repo|
      next unless rails?(repo)
      repository = client.repository(repo.full_name)
      begin
        User.create!(
          repository.owner.to_h
          .slice(*USER_ATTRIBUTES)
          .merge(
            repositories_attributes: [
              repository.to_h.slice(*REPOSITORY_ATTRIBUTES)
            ]
          )
        )
      rescue ActiveRecord::RecordNotUnique => e
        Rails.logger.error e
        Rails.logger.error e.record.attributes
      end
    end
  end

  private

  def each_repositories(&block)
    since = nil
    until (repos = client.get('repositories', since: since)).empty?
      repos.each do |repo|
        yield repo
      end
      since = repos.last.id
    end
  end

  def rails?(repo)
    contents = client.contents(repo.full_name)
    if gemfile = contents.find { |file_or_dir| file_or_dir.name == 'Gemfile' }
      client.get(gemfile.download_url) =~ /^(?:\s*)gem(?:\s+)['"]rails['"].*$/
    end
  end
end
