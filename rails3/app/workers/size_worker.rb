class SizeWorker
  include Sidekiq::Worker
  sidekiq_options queue: "resize"
  
  def perform( src, out, size )
    image = MiniMagick::Image.open( src )
    image.resize( size )
    image.format( 'jpg' )
    image.write( out )
  end
end