class SizeWorker
  include Sidekiq::Worker
  sidekiq_options queue: "resize"
  
  def perform( src, out, size )
    ImgSize.resize( src, out, size )
  end
end