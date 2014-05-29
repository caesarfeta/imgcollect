class FileUpload
  
  def save( _upload )
    #-------------------------------------------------------------
    #  Build
    #-------------------------------------------------------------
    @dir = UploadUtils.monthDir( Rails.configuration.upload_dir )
    check( _upload )
    #-------------------------------------------------------------
    #  Write the file
    #-------------------------------------------------------------
    File.open( @path, "wb" ) { |f| 
      f.write( _upload['file'].read ) 
    }
  end
  
  def check( _upload )
    @original = _upload['file'].original_filename
    path = File.join( @dir, @original )
    res = UploadUtils.filename( path )
    @path = res['path']
    @ext = res['ext']
  end
  
  def path
    @path
  end
  
  def ext
    @ext.upcase
  end
  
end