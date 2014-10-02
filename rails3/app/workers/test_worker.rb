class TestWorker
  include Sidekiq::Worker
  sidekiq_options queue: "test"
  
  def perform
    puts 'This ran?'
  end
end