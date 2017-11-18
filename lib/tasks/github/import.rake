namespace :github do
  namespace :import do
    desc 'Import resources from GitHub'
    task resources: :environment do |task, args|
      Github::User.each do |user|
        GithubResourcesImportingJob.perform_later(user.login)
      end
    end
  end
end
