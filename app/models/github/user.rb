module Github
  class User
    attr_reader :client

    include Enumerable

    def self.each(&block)
      new.each(&block)
    end

    def self.find_each(&block)
      new.find_each(&block)
    end

    def initialize
      @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    end

    def find_each
      return to_enum unless block_given?

      since = nil
      until (users = client.all_users(since: since)).empty?
        yield users
        since = user.last.id
      end
    end

    def each
      return to_enum unless block_given?

      since = nil
      until (users = client.all_users(since: since)).empty?
        users.each do |user|
          yield user
        end
        since = user.last.id
      end
    end
  end
end
