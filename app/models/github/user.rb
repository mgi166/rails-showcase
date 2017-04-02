module Github
  class User
    attr_reader :client

    include Enumerable

    def self.each(since: nil, &block)
      new.each(since: since, &block)
    end

    def self.find_each(since: nil, &block)
      new.find_each(since: since, &block)
    end

    def self.find_by_username(username)
      new.find_by_username(username)
    end

    def self.find_or_create_by_username!(username)
      ::User.find_or_create_by!(login: user.login) do |u|
        github_user = find_by_username(username)
        u.avatar_url = github_user.avatar_url
        u.html_url = github_user.html_url
      end
    rescue ActiveRecord::RecordNotUnique
    end

    def self.find_or_create_by!(user)
      github_user = find_by_username(user.login)
      ::User.find_or_create_by!(login: github_user.login) do |u|
        u.avatar_url = github_user.avatar_url
        u.html_url = github_user.html_url
      end
    rescue ActiveRecord::RecordNotUnique
    end

    def initialize
      @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    end

    def find_by_username(username)
      client.user(username)
    end

    def find_each(since: nil)
      return to_enum unless block_given?

      until (users = client.all_users(since: since)).empty?
        yield users
        since = user.last.id
      end
    end

    def each(since: nil)
      return to_enum unless block_given?

      until (users = client.all_users(since: since)).empty?
        users.each do |user|
          yield user
        end
        since = users.last.id
      end
    end
  end
end
