class UploadUtils
  
  # Create a YEAR/MONTH subdirectory
  #   ex. 2014/JAN, 2014/FEB
  # _dir { String }
  def self.monthDir( _dir )
    time = Time.now
    dir = File.join( _dir, time.year.to_s, time.strftime( '%^b' ) )
    FileUtils.mkdir_p( dir )
    return dir
  end
  
  # Get a unique filename
  # _file { String }
  # _num { Int }
  def self.filename( _file, _num=1 )
    #-------------------------------------------------------------
    #  Determine the suffix of the uploaded filename
    #-------------------------------------------------------------
    count = ''
    if _num > 1
      count = ' ' + _num.to_s
    end
    #-------------------------------------------------------------
    #  Build the new path
    #-------------------------------------------------------------
    dir = File.dirname( _file )
    ext = File.extname( _file )
    base = File.basename( _file, ext )
    file = base + count + ext
    path = File.join( dir, file )
    #-------------------------------------------------------------
    #  Check to see if the file exists already
    #-------------------------------------------------------------
    if File.file?( path )
      _num += 1
      return filename( _file, _num )
    end
    return Hash[ "original" => _file, "path" => path, "ext" => ext ]
  end
  
end