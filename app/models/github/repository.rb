module Github
  class Repository
    attr_reader :name, :full_name, :client, :description, :html_url, :stargazers_count, :forks_count

    class NoContentGemfile < StandardError; end

    def self.each(login, &block)
      return to_enum unless block_given?
      Github::RepositoryCollection.each_repos(login, &block)
    end

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
      !!gems.find { |gem| gem.respond_to?(:name) && gem.name == 'rails' }
    rescue Octokit::Error, Bundler::Dsl::DSLError, NoContentGemfile
      false
    rescue => e
      Rails.logger.info(attributes)
      raise e
    end

    def create!(user)
      ::Repository.create!(attributes.merge(user: user))
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
      fail NoContentGemfile unless gems = Bundler::Dsl.new.eval_gemfile('Gemfile', gemfile_contents)

      # NOTE: If Gemfile contents only "source 'https://rubygems.org'", Return Bundler::Source::Rubygems object.
      fail NoContentGemfile unless gems.is_a?(Array)
      gems
    end
  end
end
