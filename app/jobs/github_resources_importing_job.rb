class GithubResourcesImportingJob < ApplicationJob
  queue_as :default

  rescue_from Octokit::TooManyRequests do |e|
    retry_job wait: 1.hour
  end

  def initialize(*args)
    super

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

  def perform(login)
    ApplicationRecord.transaction do
      user = Github::User.find_by_username(login)
      user_attrs = user.attrs.slice(*Settings.bulk_importer.user_columns.map(&:to_sym))
      res = with_connection { ::User.import([user_attrs], @import_option_for_user) }
      user_id = res.ids.first

      Github::Repository.find_in_batches(user.login) do |repos|
        results = rails_repos(repos)
        next if results.blank?

        results.map! { |r| r.merge(user_id: user_id) }
        with_connection { ::Repository.import(results, @import_option_for_repo) }
      end
    end
  rescue => e
    RailsShowcase::ExceptionNotifier.notify(e)
    raise e
  end

  private

  def rails_repos(repos)
    Parallel.map(repos, in_threads: 8) do |repo|
      next unless repo.rails?
      repo.attributes
    end.compact
  end

  def with_connection
    ApplicationRecord.connection_pool.with_connection do
      yield
    end
  end
end
