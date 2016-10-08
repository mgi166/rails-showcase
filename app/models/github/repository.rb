module Github
  class Repository
    attr_reader :name, :full_name, :client, :description, :html_url, :stargazers_count, :forks_count

    def initialize(full_name, description: nil, html_url: nil, stargazers_count: nil, forks_count: nil)
      @full_name = full_name
      @name = full_name.to_s.split('/').last
      @description = description
      @html_url = html_url
      @stargazers_count = stargazers_count
      @forks_count = forks_count
      @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    end

    def rails?
      !!gems.find { |gem| gem.name == 'rails' }
    rescue Octokit::Error
      false
    rescue Bundler::Dsl::DSLError
      false
    end

    private

    def attributes
      {
        name: name,
        full_name: full_name,
        description: description,
        html_url: html_url,
        stargazers_count: stargazers_count,
        forks_count: forks_count,
      }.stringify_keys
    end

    # @raise [Octokit::NotFound] If `Gemfile` does not exist in repository, raise Octokit::NotFound
    # @raise [Octokit::RepositoryUnavailable]
    #
    def gemfile_contents
      content = client.contents(full_name, path: 'Gemfile').content
      Base64.decode64(content)
    end

    # @raise [Bundler::Dsl::DSLError] If parsing `Gemfile` is failed, raise Bundler::Dsl::DSLError
    def gems
      @gems ||= Bundler::Dsl.new.eval_gemfile('Gemfile', gemfile_contents)
    end
  end
end
