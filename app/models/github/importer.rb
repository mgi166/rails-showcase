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
          next unless repo.rails?
          create_resouces!(user, repo)
        end
      end
    end

    def import_user(login)
      Github::User.find_or_create_by_username!(login)
    end

    def import_repos(login)
      user = Github::User.find_by_username(login)
      Github::Repository.each(user.login) do |repo|
        create_resouces!(user, repo)
      end
    end

    private

    def create_resouces!(user, repo)
      u = Github::User.find_or_create_by!(user)
      repo.create!(user)
    rescue ActiveRecord::RecordNotUnique
    end
  end
end
