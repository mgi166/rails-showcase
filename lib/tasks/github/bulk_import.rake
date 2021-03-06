namespace :github do
  namespace :bulk_import do
    desc 'Import all from github'
    task :all, [:since] => :environment do |task, args|
      Github::BulkImporter.new.import_all(since: args.since)
    end

    desc 'Import users from github'
    task :users, [:since] => :environment do |task, args|
      Github::BulkImporter.new.import_all(since: args.since)
    end
  end
end
