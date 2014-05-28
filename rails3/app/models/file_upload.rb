class FileUpload
  def self.save( _upload )
    @orignal_filename =  _upload['file'].original_filename
    #-------------------------------------------------------------
    #  Make the upload directory if it doesn't already exist
    #-------------------------------------------------------------
    FileUtils.mkdir_p( Rails.configuration.upload_dir )
    #-------------------------------------------------------------
    #  Build the file path
    #-------------------------------------------------------------
    @path = File.join( Rails.configuration.upload_dir, @orignal_filename )
    #-------------------------------------------------------------
    #  Write the file
    #-------------------------------------------------------------
    File.open( @path, "wb" ) { |f| 
      f.write( _upload['file'].read ) 
    }
  end
end