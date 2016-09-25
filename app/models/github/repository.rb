module Github
  class Repository
    attr_reader :full_name, :client, :description, :html_url, :stargazers_count, :forks_count

    def initialize(full_name, description: nil, html_url: nil, stargazers_count: nil, forks_count: nil)
      @full_name = full_name
      @description = description
      @html_url = html_url
      @stargazers_count = stargazers_count
      @forks_count = forks_count
      @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    end

    def attributes
      {
        full_name: full_name,
        description: description,
        html_url: html_url,
        stargazers_count: stargazers_count,
        forks_count: forks_count,
      }.stringify_keys
    end

    def rails?
      !!gems.find { |gem| gem.name == 'rails' }
    rescue Octokit::NotFound
      false
    rescue Bundler::Dsl::DSLError
      false
    end

    private

    # @raise [Octokit::NotFound] If `Gemfile` does not exist in repository, raise Octokit::NotFound
    def gemfile_contents
      contents = client.contents(full_name, path: 'Gemfile').contents
      Base64.decode(contents)
    end

    # @raise [Bundler::Dsl::DSLError] If parsing `Gemfile` is failed, raise Bundler::Dsl::DSLError
    def gems
      @gems ||= Bundler::Dsl.new.eval_gemfile('Gemfile', gemfile_contents)
    end
  end
end
