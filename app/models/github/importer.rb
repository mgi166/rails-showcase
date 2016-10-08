module Github
  class Importer
    attr_reader :graphql_client

    def initialize
      @graphql_client = GraphQLClient.new
    end

    def import_all
      Github::User.each do |user|
        Github::Repository.each(user.login) do |repo|
          if repo.rails?
            u = create_user(user)
            create_repo(repo, u)
          end
        end
      end
    end

    private

    def create_user(user)
      ::User.find_or_create_by!(login: user.login) do |u|
        u.avatar_url = user.avatar_url
        u.html_url = user.html_url
      end
    rescue ActiveRecord::RecordNotUnique
    end

    def create_repo(repo, user)
      repo.create!(user)
    rescue ActiveRecord::RecordNotUnique
    end
  end
end
