class CropWorker
  include Sidekiq::Worker
  sidekiq_options queue: "crop"
  
  def perform( src, out, x, y, width, height )
    ImgSize.crop( src, out, x, y, width, height )
  end
end