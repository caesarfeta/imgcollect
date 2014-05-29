class ImgUpload
  
  def save( _upload )
    #-------------------------------------------------------------
    #  Build
    #-------------------------------------------------------------
    @uploadDir = UploadUtils.monthDir( Rails.configuration.upload_dir )
    check( _upload )
    #-------------------------------------------------------------
    #  Write the file
    #-------------------------------------------------------------
    File.open( @uploadPath, "wb" ) { |f| 
      f.write( _upload['file'].read ) 
    }
  end
  
  def check( _upload )
    @original = _upload['file'].original_filename
    path = File.join( @uploadDir, @original )
    res = UploadUtils.filename( path )
    @uploadPath = res['path']
    @ext = res['ext']
    @filename = res['filename']
  end
  
  def toImgDir
    @imgDir = UploadUtils.monthDir( Rails.configuration.img_dir )
    path = File.join( @imgDir, @original )
    res = UploadUtils.filename( path )
    @imgPath = res['path']
    FileUtils.cp( @uploadPath, @imgPath )
  end
  
  def report
    return Hash[ 'original' => @original, 'path' => @imgPath, 'error' => nil ]
  end
  
  def uploadPath
    @uploadPath
  end
  
  def imgPath
    @imgPath
  end
  
  def ext
    @ext.upcase
  end
  
end