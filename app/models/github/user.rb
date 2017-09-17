module Github
  class User
    attr_reader :client

    include Enumerable

    class << self
      def each(since: nil, &block)
        new.each(since: since, &block)
      end

      def find_in_batches(since: nil, &block)
        new.find_in_batches(since: since, &block)
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

    def find_in_batches(since: nil)
      return to_enum unless block_given?

      until (users = github_users(since: since)).empty?
        yield users
        since = users.last.id
      end
    end

    def each(since: nil)
      return to_enum unless block_given?

      until (users = github_users(since: since)).empty?
        users.each do |user|
          yield user
        end
        since = users.last.id
      end
    end

    private

    def github_users(params = {})
      client.all_users(params)
    end
  end
end
