require 'open-uri'
class ImgUpload
  
  # Save a file to the upload directory
  def save( _upload )

    # Build
    @uploadDir = UploadUtils.monthDir( Rails.configuration.upload_dir )
    case _upload['file'].class.to_s

      # File is an upload from the users local filesystem...
      when 'ActionDispatch::Http::UploadedFile'
        check( _upload['file'].original_filename )

        # Write the file
        File.open( @uploadPath, "wb" ) { |f| 
          f.write( _upload['file'].read ) 
        }
        
      # URL pointint to a file on 
      when 'String'
        @url = _upload['file']
        uri = URI.parse( @url )
        check( File.basename( uri.path ) )
        
        # Write the file
        open( @uploadPath, 'wb' ) do |f|
          f << open( @url ).read
        end
    end
  end
  
  # Check to make sure the filename is unique
  def check( _upload )
    @original = _upload
    path = File.join( @uploadDir, @original )
    res = UploadUtils.filename( path )
    @uploadPath = res['path']
    @ext = res['ext']
    @filename = res['filename']
  end
  
  # Copy the uploaded file to the image directory
  def toImgDir
    @imgDir = UploadUtils.monthDir( Rails.configuration.img_dir, Rails.configuration.original_dir )
    path = File.join( @imgDir, @original )
    res = UploadUtils.filename( path )
    @imgPath = res['path']
    FileUtils.cp( @uploadPath, @imgPath )
    return report
  end
  
  # Build a report of what happened
  def report
    if @url != nil
      @original = @url
    end
    return Hash[ 
      'original' => @original, 
      'path' => @imgPath, 
      'error' => nil 
    ]
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

# rest = RestTest.new( 'http://localhost:3000' )
# local = '/usr/local/imgcollect/rails3/test/fixtures/images/forest1.JPG'
# rest.post( 'image/upload', { :file => File.new( local, 'rb' ) } )
# remote = 'http://www.shiftedreality.com/wp-content/uploads/2010/07/sr_mandelbulb02.jpg'
# rest.post( 'image/upload', {:file => remote })
# 
# {"file"=>#<ActionDispatch::Http::UploadedFile:0x48729352 @original_filename="forest1.JPG", @headers="Content-Disposition: form-data; name=\"file\"; filename=\"forest1.JPG\"\r\nContent-Type: text/plain\r\n", @tempfile=#<Tempfile:/var/folders/yp/_dkxrwzd043dnbckn8w4hr880000gn/T/RackMultipart20140724-58195-13na2mj>, @content_type="text/plain">, "controller"=>"image", "action"=>"upload"}