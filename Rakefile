require 'rake'
require 'spec/rake/spectask'
require 'lib/html2json'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }


SITE =  "http://localhost"
PORT = "5984"
DATABASE = "divisionlists"


Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--colour', '--format=specdoc']
end

desc "load data"
task :load_data do
  loader = Html2Json.new()
  loader.load_data()
end