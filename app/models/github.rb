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
      begin
        next unless rails?(repo)
        repository = client.repository(repo.full_name)

        next if Repository.exists?(full_name: repository.full_name)

        user = User.find_or_create_by!(login: repository.owner.login) do |user|
          user.assign_attributes(repository.owner.to_h.slice(*USER_ATTRIBUTES))
        end
        user.repositories.create!(repository.to_h.slice(*REPOSITORY_ATTRIBUTES))
      rescue ActiveRecord::RecordNotUnique => e
        Rails.logger.error e
      rescue Octokit::Error => e
        Rails.logger.error e
      rescue => e
        Rails.logger.error e
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
