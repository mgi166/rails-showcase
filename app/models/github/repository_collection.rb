module Github
  class RepositoryCollection
    attr_reader :login, :graphql_client

    def initialize(login)
      @login = login
      @graphql_client = GraphQLClient.new
    end

    def self.each_repos(login, &block)
      new(login).each_repos(&block)
    end

    def each_repos
      return to_enum unless block_given?

      next_page = true
      after = ''

      while next_page
        result = graphql_client.repository_owner(login, repository_opts: { after: after })

        # https://github.com/github/graphql-client/blob/ad6b582e9d57b7c5d8203e69be57c1e808351969/lib/graphql/client/response.rb#L13-L33
        next unless result.respond_to?(:data)

        data = Hashie::Mash.new(result.data.to_h)

        data.repositoryOwner.repositories.edges.each do |edge|
          node = edge.node
          yield Github::Repository.new(
            "#{login}/#{node.name}",
            description: node.description,
            html_url: node.homepageURL,
            forks_count: node.forks.totalCount,
            stargazers_count: node.stargazers.totalCount,
          )
        end

        page_info = data.repositoryOwner.repositories.pageInfo

        after = page_info.endCursor
        next_page = page_info.hasNextPage
      end
    end
  end
end
