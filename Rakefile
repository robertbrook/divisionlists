require 'rake'
require 'spec/rake/spectask'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }


SITE =  "http://localhost"
PORT = "5984"
DATABASE = "divisionlists"


Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--colour', '--format=specdoc']
end