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
            #{repositories_query(first: first, after: after, isFork: false, privacy: 'PUBLIC')}
          }
        }
      GRAPHQL
    end

    # NOTE: params definition references query > repositoryOwner > repositories.
    #       https://developer.github.com/early-access/graphql/explorer/
    #
    # * first: Int
    #   * Returns the first n elements from the list.
    # * after: String
    #   * Returns the elements in the list that come after the specified global ID.
    # * last: Int
    #   * Returns the last n elements from the list.
    # * before: String
    #   * Returns the elements in the list that come before the specified global ID.
    # * privacy: RepositoryPrivacy
    #   * If non-null, filters repositories according to privacy
    # * isFork: Boolean
    #   * If non-null, filters repositories according to whether they are forks of another repository
    # * orderBy: RepositoryOrder
    #   * Ordering options for repositories returned from the connection
    # * affiliation: [RepositoryAffiliation]
    #   * Affiliation options for repositories returned from the connection
    # * isLocked: Boolean
    #   * If non-null, filters repositories according to whether they have been locked
    def repositories_query(params)
      args = params
               .with_indifferent_access
               .slice(
                 :first,
                 :after,
                 :last,
                 :before,
                 :privacy,
                 :isFork,
                 :orderBy,
                 :affiliation,
                 :isLocked
               )

      <<~GRAPHQL
        repositories(#{inspect_args(args)}) {
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
              homepageUrl
              createdAt
              pushedAt
              forks {
                totalCount
              }
              stargazers {
                totalCount
              }
            }
          }
        }
      GRAPHQL
    end

    private

    def inspect_args(hash)
      hash.each_with_object([]) do |(k, v), r|
        next if v.blank?
        r << "#{k}: #{v}"
      end.join(', ')
    end
  end
end
