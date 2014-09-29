class CropWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  
  def perform( src, res, x, y, width, height )
    image = MiniMagick::Image.open( src )
    px_w = ( image[:width] * width.to_f ).floor
    px_h = ( image[:height ] * height.to_f ).floor
    px_x = ( image[:width] * x.to_f ).floor
    px_y = ( image[:height] * y.to_f ).floor
    image.crop( "#{px_w}x#{px_h}+#{px_x}+#{px_y}" )
    image.write( res['path'] )
  end
end