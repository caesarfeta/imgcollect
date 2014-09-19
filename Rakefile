require 'rake/testtask'
require 'sparql_model'

RDF_DATA = "/usr/local/imgcollect/triples"
SPARQL_HOST = "http://localhost"
SPARQL_PORT = "8080"
SPARQL_DATA = "ds"
SPARQL_ENDPOINT = "#{SPARQL_HOST}:#{SPARQL_PORT}/#{SPARQL_DATA}"
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
    `touch #{FUSEKI_PID}; ./fuseki-server --update --loc=#{RDF_DATA} --port=#{SPARQL_PORT} /#{SPARQL_DATA}& echo $! > #{FUSEKI_PID}`
  end
end

namespace :stop do
  desc 'Stop rails server'
  task :rails do
    Process.kill 15, File.read( RAILS_PID ).to_i
  end
  
  desc 'Stop fuseki server'
  task :fuseki do
    Process.kill 15, File.read( "#{FUSEKI}/#{FUSEKI_PID}" ).to_i
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
      quick = SparqlQuick.new( SPARQL_ENDPOINT )
      quick.empty( :all )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
  
end