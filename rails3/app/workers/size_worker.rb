class SizeWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  
  def perform( src, size, res )
    image = MiniMagick::Image.open( src )
    image.resize( size )
    image.format( 'jpg' )
    image.write( res['path'] )
  end
end