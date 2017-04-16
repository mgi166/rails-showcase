module Github
  class RepositoryCollection
    attr_reader :login, :graphql_client

    def initialize(login)
      @login = login
      @graphql_client = GraphQLClient.new
    end

    def self.each_repo(login, &block)
      new(login).each_repo(&block)
    end

    def self.each_repos(login, &block)
      new(login).each_repos(&block)
    end

    def each_repo
      each_data do |data|
        data.repositoryOwner.repositories.edges.each do |edge|
          node = edge.node
          yield Github::Repository.new(
            "#{login}/#{node.name}",
            description: node.description,
            html_url: node.homepageURL,
            forks_count: node.forks.totalCount,
            stargazers_count: node.stargazers.totalCount,
            pushed_at: node.pushedAt,
          )
        end
      end
    end

    def each_repos
      each_data do |data|
        repos = data.repositoryOwner.repositories.edges.map do |edge|
          node = edge.node
          Github::Repository.new(
            "#{login}/#{node.name}",
            description: node.description,
            html_url: node.homepageURL,
            forks_count: node.forks.totalCount,
            stargazers_count: node.stargazers.totalCount,
            pushed_at: node.pushedAt,
          )
        end
        yield repos
      end
    end

    private

    def each_data
      return to_enum unless block_given?

      next_page = true
      after = ''

      while next_page
        result = graphql_client.repository_owner(login, repository_opts: { after: after })

        # https://github.com/github/graphql-client/blob/ad6b582e9d57b7c5d8203e69be57c1e808351969/lib/graphql/client/response.rb#L13-L33
        next unless result.respond_to?(:data)

        data = Hashie::Mash.new(result.data.to_h)
        yield data

        page_info = data.repositoryOwner.repositories.pageInfo
        after = %Q("#{page_info.endCursor}")
        next_page = page_info.hasNextPage
      end
    end
  end
end
