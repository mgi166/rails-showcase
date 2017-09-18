module Github
  class Importer
    def import!(options = {})
      Github::User.each(options) do |user|
        begin
          GithubResourcesImportingJob.perform_later(user.login)
        rescue => e
          RailsShowcase::ExceptionNotifier.notify(e)
        end
      end
    end
  end
end
