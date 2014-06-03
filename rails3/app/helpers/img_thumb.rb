class ImgThumb
  
  def self.create( _src )
    #-------------------------------------------------------------
    #  Build the thumb directory
    #-------------------------------------------------------------
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.thumb_dir )
    #-------------------------------------------------------------
    #  Build the thumbnail filename
    #-------------------------------------------------------------
    file = File.basename( _src )
    path = File.join( dir, file )
    res = UploadUtils.filename( path )
    #-------------------------------------------------------------
    #  Create the thumbnail
    #-------------------------------------------------------------
    image = MiniMagick::Image.open( _src )
    dim = Rails.configuration.thumb_max_width.to_s + 'x' + Rails.configuration.thumb_max_height.to_s
    image.resize( dim )
    image.write( res['path'] )
    return res['path']
  end
  
end