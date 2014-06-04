class ImgMeta
  
  # _file { String } The file path
  def self.exif( _file, _format=nil )
    _format = _format.to_s.upcase
    #-------------------------------------------------------------
    #  Is the file a JPEG?
    #-------------------------------------------------------------
    type = ::MimeMagic.by_path( _file ).to_s
    if type != 'IMAGE/JPEG'
      raise "File format ( #{ type } ) is not supported"
    end
    #-------------------------------------------------------------
    #  Get the EXIFR data
    #-------------------------------------------------------------
    jpeg = self.exif_jpeg( _file )
    if jpeg.exif? == false
      raise "No exif data found for #{ _file }"
    end
    #-------------------------------------------------------------
    #  Return json if requested
    #-------------------------------------------------------------
    if _format == 'JSON'
      return jpeg.exif.to_json
    end
    #-------------------------------------------------------------
    #  Return a ruby hash
    #-------------------------------------------------------------
    return jpeg.exif
  end
  
  def self.exif_jpeg( _file )
    return EXIFR::JPEG.new( _file )
  end
  
end
