class ImgMeta
  
  # _file { String } The file path
  def self.exif( _file, _format=nil )
    _format = _format.to_s.upcase
    #-------------------------------------------------------------
    #  Is the file a JPEG?
    #-------------------------------------------------------------
    type = ::MimeMagic.by_path( _file ).to_s.upcase
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
    hash = jpeg.exif[0].to_hash
    #-------------------------------------------------------------
    #  Some values need to have their types converted
    #-------------------------------------------------------------
    #hash[:orientation] = hash[:orientation].to_s # Don't know how to handle this
    hash[:orientation] = nil
    hash[:date_time] = hash[:date_time].to_i
    hash[:date_time_original] = hash[:date_time_original].to_i
    hash[:date_time_digitized] = hash[:date_time_digitized].to_i
    #-------------------------------------------------------------
    #  And you're out!
    #-------------------------------------------------------------
    return hash
  end
  
  # _file { String } The file path
  def self.exif_jpeg( _file )
    return EXIFR::JPEG.new( _file )
  end  
end
