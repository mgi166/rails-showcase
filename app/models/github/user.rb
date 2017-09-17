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

      def find_or_create_by_username!(username)
        ::User.find_or_create_by!(login: username) do |u|
          github_user = find_by_username(username)
          u.avatar_url = github_user.avatar_url
          u.html_url = github_user.html_url
        end
      rescue ActiveRecord::RecordNotUnique
      end

      def find_or_create_by!(user)
        ::User.find_or_create_by!(login: user.login) do |u|
          github_user = find_by_username(user.login)
          u.avatar_url = github_user.avatar_url
          u.html_url = github_user.html_url
        end
      rescue ActiveRecord::RecordNotUnique
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

      until (users = github_users(options)).empty?
        users.each do |user|
          yield user
        end
        since = users.last.id
      end
    end

    private

    def github_users(params = {})
      client.search_users(
        "repos:>1 language:ruby",
        params.reverse_merge(
          sort: :joined,
          order: :asc,
          per_page: 100,
          page: 1,
        )
      )
    end
  end
end
