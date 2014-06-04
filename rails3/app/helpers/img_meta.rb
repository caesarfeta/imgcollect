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
    return jpeg.exif
  end
  
  # _file { String } The file path
  def self.exif_jpeg( _file )
    return EXIFR::JPEG.new( _file )
  end
  
  # _s { String }
  # _file { String }
  def self.triples( _s, _file )
    jpeg = self.exif( _file )
    self.tripleDrill( _s, jpeg.fields )
  end
  
  # _s { String }
  # _h { Hash }
  def self.tripleDrill( _s, _hash )
    _hash.each do | key, val |
        check = val.class.to_s
        if check.include?( "EXIFR::TIFF::Orientation" )
          puts "#{_s} rdf:#{key} \"#{val.to_i}\" ."
        elsif check.include?( "EXIFR::TIFF::IFD" )
          self.tripleDrill( _s, val.to_hash )
        else
          puts "#{_s} rdf:#{key} \"#{val}\" ."
        end
    end
  end
  
end
