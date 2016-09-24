require 'graphql/client/http'

module Github
  class GraphQLClient
    attr_reader :client

    def initialize
      # https://developer.github.com/early-access/graphql/guides/accessing-graphql/#using-curl-or-your-own-http-speaking-library)
      http = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
        def headers(_context)
          { "Authorization": "bearer #{ENV['GITHUB_ACCESS_TOKEN']}"}
        end
      end
      @client = GraphQL::Client.new(execute: http)
    end

    def repository_owner(owner_name, repository_opts: {})
      graphql = repository_owner_query(owner_name, after: repository_opts[:after])
      query = define_query(graphql)
      client.query(query)
    end

    private

    def define_query(query)
      client.parse(query)
    end

    # FIXME: Fixed repositories options.
    def repository_owner_query(owner_name, first: 30, after: '')
      <<~GRAPHQL
        query {
          repositoryOwner(login: "#{owner_name}") {
            repositories(first: #{first}, after: "#{after}", isFork: false, privacy: PUBLIC) {
              totalCount
              pageInfo {
                endCursor
                hasNextPage
                hasPreviousPage
                startCursor
              }
              edges {
                node {
                  name
                  isLocked
                  isMirror
                  description
                  homepageURL
                  forks {
                    totalCount
                  }
                  stargazers {
                    totalCount
                  }
                }
              }
            }
          }
        }
      GRAPHQL
    end
  end
end
