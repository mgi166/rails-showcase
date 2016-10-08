module Github
  class Importer
    def self.import_all(since: nil)
      new.import_all(since: since)
    end

    def self.import_user(login)
      new.import_user(login)
    end

    def self.import_repos(login)
      new.import_repos(login)
    end

    def import_all(since: nil)
      Github::User.each(since: since) do |user|
        Github::Repository.each(user.login) do |repo|
          if repo.rails?
            u = create_user(user)
            create_repo(repo, u)
          end
        end
      end
    end

    def import_user(login)
      user = Github::User.find_by_username(login)
      create_user(user)
    end

    def import_repos(login)
      user = Github::User.find_by_username(login)
      Github::Repository.each(user.login) do |repo|
        if repo.rails?
          u = create_user(user)
          create_repo(repo, u)
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
