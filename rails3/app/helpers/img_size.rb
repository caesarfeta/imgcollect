class ImgSize
  include Sidekiq::Worker
  sidekiq_options queue: "high"
    
  def self.thumb( src )
    dim = Rails.configuration.thumb_max_width.to_s + 'x' + Rails.configuration.thumb_max_height.to_s
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.thumb_dir )
    self.bg_resize( src, dim, dir )
  end
  
  def self.basic( src )
    dim = Rails.configuration.basic_max_width.to_s + 'x' + Rails.configuration.basic_max_height.to_s
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.basic_dir )
    self.bg_resize( src, dim, dir )
  end
  
  def self.advanced( src )
    dim = Rails.configuration.advanced_max_width.to_s + 'x' + Rails.configuration.advanced_max_height.to_s
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.advanced_dir )
    self.bg_resize( src, dim, dir )
  end
  
  # ImgSize.subregion( "/usr/local/imgcollect/images/2014/SEP/original/travel-to-hungary.jpg", 0.5, 0, 0.5, 0.5 )
  def self.subregion( src, x, y, width, height )
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.subregion_dir )
    res = self.uniq_path( src, dir )
    CropWorker.perform_async( src, res['path'], x, y, width, height )
    res['path']
  end
  
  def self.bg_resize( src, size, dir )
    res = self.uniq_path( src, dir, 'jpg' )
    SizeWorker.perform_async( src, res['path'], size )
    res['path']
  end
  
  def self.crop( src, out, x, y, width, height )
    image = MiniMagick::Image.open( src )
    px_w = ( image[:width] * width.to_f ).floor
    px_h = ( image[:height ] * height.to_f ).floor
    px_x = ( image[:width] * x.to_f ).floor
    px_y = ( image[:height] * y.to_f ).floor
    image.crop( "#{px_w}x#{px_h}+#{px_x}+#{px_y}" )
    image.write( out )
  end
  
  def self.resize( src, out, size )
    image = MiniMagick::Image.open( src )
    image.resize( size )
    image.format( 'jpg' )
    image.write( out )
  end
  
  def self.convert( src, dir )
  end
  
  # ImgSize.uniq_path( "/usr/local/imgcollect/images/2014/SEP/original/travel-to-hungary.tiff", "/usr/local/imgcollect/images/2014/SEP/thumb/" )
  def self.uniq_path( src, dir, form=nil )
    ext =  File.extname( src )
    if form == nil
      form = ext
    end
    form = form.predot
    file = File.basename( src, ext )
    path = File.join( dir, "#{file}#{form}" )
    UploadUtils.filename( path )
  end
  
  # Save a placeholder image
  def self.placehold( path, size )
    
  end
  
end