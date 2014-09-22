require 'rake/testtask'
require 'sparql_model'

FUSEKI_VERSION = "1.0.2"
FUSEKI_DIR = "jena-fuseki-#{FUSEKI_VERSION}"
FUSEKI_TAR = "#{FUSEKI_DIR}-distribution.tar.gz"
FUSEKI_EXE = "fuseki/#{FUSEKI_DIR}/fuseki-server"
FUSEKI_TRIPLES = "/usr/local/imgcollect/triples"
FUSEKI_HOST = "http://localhost"
FUSEKI_PORT = "8080"
FUSEKI_DATA = "ds"
FUSEKI_ENDPOINT = "#{FUSEKI_HOST}:#{FUSEKI_PORT}/#{FUSEKI_DATA}"
RAILS = 'rails3'
RAILS_PID = "#{RAILS}/tmp/pids/server.pid"
RAILS_ENV = 'development'
FUSEKI = 'fuseki'
FUSEKI_PID = "fuseki.pid"

desc "Run tests"
task :default => :test

namespace :start do
  desc 'Start rails server'
  task :rails do
  	Dir.chdir( RAILS )
  	`bundle exec rails server -e #{RAILS_ENV}`
  end
  
  desc 'Start fuseki'
  task :fuseki do
    Dir.chdir( FUSEKI )
    `touch #{FUSEKI_PID}; ./fuseki-server --update --loc=#{FUSEKI_TRIPLES} --port=#{FUSEKI_PORT} /#{FUSEKI_DATA}& echo $! > #{FUSEKI_PID}`
  end
end

namespace :deploy do
  desc 'Deploy imgcollect in Apache with Phusion Passenger'
  task :apche do
    puts "TODO..."
  end
end

namespace :install do
  desc 'Download and install Fuseki'
  task :fuseki do
    `curl -O http://archive.apache.org/dist/jena/binaries/#{FUSEKI_TAR}`
    `mkdir fuseki`
    `tar xzvf #{FUSEKI_TAR} -C fuseki`
    `chmod +x #{FUSEKI_EXE} fuseki/#{FUSEKI_DIR}/s-**`
    `rm #{FUSEKI_TAR}`
  end
  
  desc 'Install rails and dependencies'
  task :rails do
    Dir.chdir( RAILS )
    `bundle install`
  end
end

namespace :stop do
  desc 'Stop rails server'
  task :rails do
    Process.kill 15, File.read( RAILS_PID ).to_i
  end
  
  desc 'Stop fuseki server'
  task :fuseki do
    puts "TODO..."
  end
end

namespace :destroy do
  desc 'Destroy all upload data'
  task :uploads do
    STDOUT.puts "Are you sure you want to destroy all uploads? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      FileUtils.rm_rf( 'uploads' )
      FileUtils.mkdir( 'uploads' )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
  
  desc 'Destroy image data'
  task :images do
    STDOUT.puts "Are you sure you want to destroy all images? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      FileUtils.rm_rf( 'images' )
      FileUtils.mkdir( 'images' )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
  
  desc 'Destroy triples'
  task :triples do
    STDOUT.puts "Are you sure you want to destroy all triples? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      quick = SparqlQuick.new( FUSEKI_ENDPOINT )
      quick.empty( :all )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
end