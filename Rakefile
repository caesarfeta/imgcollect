require 'rake/testtask'
require 'sparql_model'

IMGCOLLECT = File.dirname(__FILE__)
FUSEKI_VERSION = "1.0.2"
FUSEKI_DIR = "jena-fuseki-#{FUSEKI_VERSION}"
FUSEKI_TAR = "#{FUSEKI_DIR}-distribution.tar.gz"
FUSEKI_EXE = "fuseki/#{FUSEKI_DIR}/fuseki-server"
FUSEKI_TRIPLES = "#{IMGCOLLECT}/triples"
FUSEKI_HOST = "http://localhost"
FUSEKI_PORT = "4321"
FUSEKI_DATA = "ds"
FUSEKI_ENDPOINT = "#{FUSEKI_HOST}:#{FUSEKI_PORT}/#{FUSEKI_DATA}"
FUSEKI = "fuseki"
FUSEKI_PID = "fuseki.pid"
RAILS = "#{IMGCOLLECT}/rails3"
RAILS_CONFIG = "#{RAILS}/config"
RAILS_ENV = "development"
REDIS_CONFIG = "#{RAILS_CONFIG}/redis.conf"
SIDEKIQ_CONFIG = "#{RAILS_CONFIG}/sidekiq.yml"
LOG = "#{RAILS}/log"

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
    Dir.chdir( "#{FUSEKI_DIR}" )
      `mkdir -p #{FUSEKI_TRIPLES}`
      `touch ../#{FUSEKI_PID}; ./fuseki-server --update --loc=#{FUSEKI_TRIPLES} --port=#{FUSEKI_PORT} /#{FUSEKI_DATA}& echo $! > ../pids/#{FUSEKI_PID}`
  end
  
  desc 'Start sidekiq'
  task :sidekiq do
    `redis-server #{REDIS_CONFIG}`
    Dir.chdir( RAILS )
      `bundle exec sidekiq -C #{SIDEKIQ_CONFIG} -d -L #{LOG}/sidekiq.log`
  end
  
  desc 'Start rails & fuseki'
  task :all do
    Rake::Task["start:fuseki"].invoke
    Rake::Task["start:sidekiq"].invoke
    Rake::Task["start:rails"].invoke
  end
end

namespace :deploy do
  desc 'Deploy imgcollect in apache with Phusion Passenger'
  task :apache do
    puts "TODO..."
  end
end

namespace :install do
  desc 'Download & install fuseki'
  task :fuseki do
    `curl -O http://archive.apache.org/dist/jena/binaries/#{FUSEKI_TAR}`
    `mkdir fuseki`
    `tar xzvf #{FUSEKI_TAR} -C #{FUSEKI}`
    `chmod +x #{FUSEKI_EXE} #{FUSEKI}/#{FUSEKI_DIR}/s-**`
    `rm #{FUSEKI_TAR}`
  end
  
  desc 'Install rails & dependencies'
  task :rails do
    Dir.chdir( RAILS )
    `bundle install`
  end
end

namespace :stop do
  desc 'Stop rails server'
  task :rails do
    Process.kill( 15, File.read( RAILS_PID ).to_i )
  end
  
  desc 'Stop fuseki server'
  task :fuseki do
    puts "TODO..."
  end
  
  desc 'Stop sidekiq'
  task :sidekiq do
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
  
  desc 'Destroy logs'
  task :logs do
    STDOUT.puts "Are you sure you want to destroy all the logs? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      FileUtils.rm_rf( "#{RAILS}/log" )
      FileUtils.mkdir( "#{RAILS}/log" )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
  
  desc 'Destroy all data'
  task :all do
    Rake::Task["destroy:uploads"].invoke
    Rake::Task["destroy:images"].invoke
    Rake::Task["destroy:triples"].invoke
    Rake::Task["destroy:logs"].invoke
  end
end
