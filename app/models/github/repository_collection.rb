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

        result.repositoryOwner.repositories.edges.each do |edge|
          node = edge.node
          yield Github::Repository.new(
            "#{login}/#{node.name}",
            description: node.description,
            html_url: node.homepageURL,
            forks_count: node.forks.totalCount,
            stargazers_count: node.stargazers.totalCount,
          )
        end

        page_info = result.repositoryOwner.repositories.pageInfo

        after = page_info.endCursor
        next_page = page_info.hasNextPage
      end
    end
  end
end
