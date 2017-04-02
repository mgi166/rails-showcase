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

    def bulk_import_repos(login)
      user = Github::User.find_by_username(login)
      user = Github::User.create!(user)
      Github::Repository.find_each(user.login) do |repos|
        begin
          options = {
            on_duplicate_key_update: {
              conflict_target: [:full_name],
              columns: [
                :name,
                :full_name,
                :description,
                :html_url,
                :stargazers_count,
                :forks_count
              ],
            }
          }

          results = rails_repos(repos, user)
          ::Repository.import(results, options) if results.present?
        rescue ActiveRecord::RecordNotUnique => e
          RailsShowcase::ExceptionNotifier.notify(e)
        end
      end
    end

    private

    def create_resouces!(user, repo)
      u = Github::User.find_or_create_by!(user)
      repo.create!(user)
    rescue ActiveRecord::RecordNotUnique
    end

    def rails_repos(repos, user)
      Parallel.map(repos, in_threads: 8) do |repo|
        next unless repo.rails?
        repo.build(user)
      end.compact
    end
  end
end
