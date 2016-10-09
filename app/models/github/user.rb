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
        since = user.last.id
      end
    end
  end
end
