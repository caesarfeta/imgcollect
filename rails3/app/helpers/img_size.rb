class ImgSize
  
  def self.thumb( _src )
    dim = Rails.configuration.thumb_max_width.to_s + 'x' + Rails.configuration.thumb_max_height.to_s
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.thumb_dir )
    self.create( _src, dim, dir )
  end
  
  def self.basic( _src )
    dim = Rails.configuration.basic_max_width.to_s + 'x' + Rails.configuration.basic_max_height.to_s
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.basic_dir )
    self.create( _src, dim, dir )
  end
  
  def self.advanced( _src )
    dim = Rails.configuration.advanced_max_width.to_s + 'x' + Rails.configuration.advanced_max_height.to_s
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.advanced_dir )
    self.create( _src, dim, dir )
  end
  
  def self.create( _src, _size, _dir )
    #  Build the thumbnail filename
    file = File.basename( _src )
    path = File.join( _dir, file )
    res = UploadUtils.filename( path )

    #  Create the thumbnail
    image = MiniMagick::Image.open( _src )
    image.resize( _size )
    image.write( res['path'] )
    res['path']
  end
  
end