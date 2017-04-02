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

    def self.create!(user)
      ::User.find_or_create_by!(login: user.login) do |u|
        u.avatar_url = user.avatar_url
        u.html_url = user.html_url
      end
    rescue ActiveRecord::RecordNotUnique
    end

    def self.find_or_create_by!(user)
      github_user = Github::User.find_by_username(user.login)
      Github::User.create!(github_user)
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
