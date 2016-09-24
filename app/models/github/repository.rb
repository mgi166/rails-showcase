module Github
  class Repository
    attr_reader :full_name, :client

    def initialize(full_name)
      @full_name = full_name
      @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
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
