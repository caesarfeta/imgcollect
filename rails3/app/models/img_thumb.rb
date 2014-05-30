class ImgThumb
  
  def self.create( _src )
    #-------------------------------------------------------------
    #  Build the thumb directory
    #-------------------------------------------------------------
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.thumb_dir )
    #-------------------------------------------------------------
    #  Build the thumbnail filename
    #-------------------------------------------------------------
    dim = Rails.configuration.thumb_max_width.to_s + 'x' + Rails.configuration.thumb_max_height.to_s
    dir = File.dirname( _file )
    ext = File.extname( _file )
    base = File.basename( _file, ext )
    file = base + count + dim + ext
    path = File.join( dir, file )
    res = UploadUtils.filename( path )
    #-------------------------------------------------------------
    #  Resize the source image and save it
    #-------------------------------------------------------------
    image = MiniMagick::Image.open( _src )
    image.resize( dim )
    image.write( res['path'] )
    return res['path']
  end
  
end