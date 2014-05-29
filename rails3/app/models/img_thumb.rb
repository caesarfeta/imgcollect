class ImgThumb
  
  def self.create( _src )
    dir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.thumb_dir )
    file = File.basename( _src )
    path = File.join( dir, file )
    res = UploadUtils.filename( path )
#    Image.resize( _src, res['path'], Rails.configuration.thumb_max_width, Rails.configuration.thumb_max_height )
    return res['path']
  end
  
end