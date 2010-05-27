require 'rake'
require 'spec/rake/spectask'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }


SITE =  "http://localhost"
PORT = "5984"
DATABASE = "divisionlists"


Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--colour', '--format=specdoc']
end

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
  
  task :environment do
    require 'active_record'
    #ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :dbfile =>  'db/test.sqlite3.db'
  end
end