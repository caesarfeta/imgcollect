class FileUpload
  
  #-------------------------------------------------------------
  #  Make the upload directory if it doesn't already exist
  #-------------------------------------------------------------
  def self.mkdir
    time = Time.now
    @dir = File.join( Rails.configuration.upload_dir, time.year.to_s, time.strftime( '%^b' ) )
    FileUtils.mkdir_p( @dir )
  end
  
  def self.filename( _name, _num=1 )
    #-------------------------------------------------------------
    #  Determine the suffix of the uploaded filename
    #-------------------------------------------------------------
    count = ''
    if _num > 1
      count = ' ' + _num.to_s
    end
    ext = File.extname( _name )
    base = File.basename( _name, ext )
    @local_filename = base + count + ext
    #-------------------------------------------------------------
    #  Build the file path
    #-------------------------------------------------------------
    @path = File.join( @dir, @local_filename )
    puts @local_filename
    #-------------------------------------------------------------
    #  Check to see if the file exists already
    #-------------------------------------------------------------
    if File.file?( @path )
      _num += 1
      filename( _name, _num )
    end
  end
  
  def self.check( _upload )
    @original_filename = _upload['file'].original_filename
    filename( @original_filename )
  end
  
  def self.save( _upload )
    mkdir
    check( _upload )
    #-------------------------------------------------------------
    #  Write the file
    #-------------------------------------------------------------
    File.open( @path, "wb" ) { |f| 
      f.write( _upload['file'].read ) 
    }
  end
end