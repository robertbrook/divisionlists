require 'rest_client'

namespace :couchmigrate do
  desc "Creates a database in CouchDB"
  task :create_db do
    unless (database = ENV['db']).nil?
      begin
        RestClient.get "#{SITE}:#{PORT}/#{ENV['db']}"
        puts "Database #{ENV['db']} already exists in #{SITE}"
      rescue RestClient::ResourceNotFound
        RestClient.put "#{SITE}:#{PORT}/#{ENV['db']}", ""
        puts "Database #{ENV['db']} created in #{SITE}"
      end
    else
      puts "You need to specify a database. Usage: rake couchmigrate:create_db db=<database_name>"
    end
  end

  desc "Deletes a database from CouchDB"
  task :delete_db do
    unless (database = ENV['db']).nil?
      begin
        RestClient.get "#{SITE}:#{PORT}/#{ENV['db']}"
        RestClient.delete "#{SITE}:#{PORT}/#{ENV['db']}"
        puts "Database #{ENV['db']} deleted from #{SITE}"
      rescue RestClient::ResourceNotFound
        puts "Database #{ENV['db']} does not exist in #{SITE}"
      end
    else
      puts "You need to specify a database. Usage: rake couchmigrate:delete_db db=<database_name>"
    end
  end
end