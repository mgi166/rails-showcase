module Github
  class BulkImporter
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

    def import_users(since: nil)
      Github::User.find_in_batches(since: nil) do |users|
        bulk_import_users(users)
      end
    end

    def import_repos(login)
      user = Github::User.find_or_create_by_username!(login)
      Github::Repository.find_in_batches(user.login) do |repos|
        bulk_import_repos(user)
      end
    end

    def import_all(since: nil)
      Github::User.find_in_batches(since: nil) do |users|
        results = bulk_import_users(users)
        bulk_import_resources(
          ::User.where(id: results.ids)
        )
      end
    end

    private

    def rails_repos(repos, user)
      Parallel.map(repos, in_threads: 8) do |repo|
        next unless repo.rails?
        repo.build(user)
      end.compact
    end

    def bulk_import_resources(users)
      Parallel.map(users) do |user|
        bulk_import_repos(user)
      end
    end

    def bulk_import_users(users)
      values = users.map { |u| u.attrs.slice(*Settings.bulk_importer.user_columns) }
      ::User.import(values, @import_option_for_user)
    end

    def bulk_import_repos(user)
      Github::Repository.find_in_batches(user.login) do |repos|
        results = rails_repos(repos, user)
        ::Repository.import(results, @import_option_for_repo) if results.present?
      end
    end
  end
end
