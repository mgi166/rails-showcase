module Github
  class BulkImporter
    COLUMN_NAMES = %i(login avatar_url html_url)
    USER_IMPORT_OPTIONS = {
      on_duplicate_key_update: {
        conflict_target: [:login],
        columns: [
          :login,
          :avatar_url,
          :html_url,
        ],
      },
      validate: false
    }.freeze
    REPO_IMPORT_OPTIONS = {
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

    def import_users(since: nil)
      Github::User.find_each(since: nil) do |users|
        values = users.map { |u| u.attrs.slice(*COLUMN_NAMES) }
        ::User.import(values, USER_IMPORT_OPTIONS)
      end
    end

    def bulk_import_repos(login)
      user = Github::User.find_or_create_by_username!(login)
      Github::Repository.find_each(user.login) do |repos|
        results = rails_repos(repos, user)
        ::Repository.import(results, REPO_IMPORT_OPTIONS) if results.present?
      end
    end

    private

    def rails_repos(repos, user)
      Parallel.map(repos, in_threads: 8) do |repo|
        next unless repo.rails?
        repo.build(user)
      end.compact
    end
  end
end
