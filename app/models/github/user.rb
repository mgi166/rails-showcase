module Github
  class User
    attr_reader :client

    include Enumerable

    class << self
      def each(options = {}, &block)
        new.each(options, &block)
      end

      def find_by_username(username)
        new.find_by_username(username)
      end
    end

    def initialize
      @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    end

    def find_by_username(username)
      client.user(username)
    end

    # @param options [Hash] Sort and pagination options
    # @option options [String] :sort Sort field
    # @option options [String] :order Sort order (asc or desc)
    # @option options [Integer] :page Page of paginated results
    # @option options [Integer] :per_page Number of items per page
    # @return [Sawyer::Resource] Search results object
    # @see https://developer.github.com/v3/search/#search-users
    #
    def each(options = {})
      return to_enum unless block_given?

      # NOTE: GitHub Search api only provides up to 1,000 result.
      #       https://developer.github.com/v3/search/#about-the-search-api
      per_page = options[:per_page].presence || 100
      max_page = (1000 % per_page).zero? ? 1000 / per_page : 1000 / per_page + 1
      (1..max_page).each do |n|
        github_users(options.merge(page: n)).items.each do |user|
          yield user
        end
      end
    end

    private

    def github_users(options = {})
      client.search_users(
        "repos:>1 language:ruby",
        options.reverse_merge(
          sort: :joined,
          order: :asc,
          per_page: 100,
          page: 1,
        )
      )
    end
  end
end
