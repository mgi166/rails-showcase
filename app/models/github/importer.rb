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

    def initialize
      @import_option_for_user = {
        on_duplicate_key_update: {
          conflict_target: [:login],
          columns: Settings.bulk_importer.user_columns
        },
        validate: false
      }

      @import_option_for_repo = {
        on_duplicate_key_update: {
          conflict_target: [:name_with_owner],
          columns: Settings.bulk_importer.repository_columns
        }
      }
    end

    def import!(login)
      ApplicationRecord.transaction do
        user = Github::User.find_by_username(login)

        Github::Repository.find_in_batches(user.login) do |repos|
          results = rails_repos(repos)
          next if results.blank?

          user_attrs = user.attrs.slice(*Settings.bulk_importer.user_columns.map(&:to_sym))
          res = ::User.import([user_attrs], @import_option_for_user)
          results.map! { |r| r.merge(user_id: res.ids.first) }
          ::Repository.import(results, @import_option_for_repo)
        end
      end
    end

    def import_all(since: nil)
      Github::User.each(since: since) do |user|
        Github::Repository.each(user.login) do |repo|
          next unless repo.rails?
          create_resouces!(user, repo)
        end
      end
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
      repo.create!(u)
    rescue ActiveRecord::RecordNotUnique
    end

    def rails_repos(repos)
      Parallel.map(repos, in_threads: 8) do |repo|
        next unless repo.rails?
        repo.attributes
      end.compact
    end
  end
end
