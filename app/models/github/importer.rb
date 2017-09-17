module Github
  class Importer
    def initialize
      @import_option_for_user = {
        on_duplicate_key_update: {
          conflict_target: [:login],
          columns: Settings.bulk_importer.user_columns
        }
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
        user_id = user.id

        user_attrs = user.attrs.slice(*Settings.bulk_importer.user_columns.map(&:to_sym))
        res = ::User.import([user_attrs], @import_option_for_user)

        Github::Repository.find_in_batches(user.login) do |repos|
          results = rails_repos(repos)
          next if results.blank?

          results.map! { |r| r.merge(user_id: user_id) }
          ::Repository.import(results, @import_option_for_repo)
        end
      end
    end

    private

    def rails_repos(repos)
      Parallel.map(repos, in_threads: 8) do |repo|
        next unless repo.rails?
        repo.attributes
      end.compact
    end
  end
end
