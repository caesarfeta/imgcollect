class UploadController < ActionController::Base
  def index
    render :file => 'app/views/upload/form.haml'
  end
  def file
    #-------------------------------------------------------------
    #  Save the file
    #-------------------------------------------------------------
    file = FileUpload.new
    file.save( params )
    #-------------------------------------------------------------
    #  Check the file type because zip files need to be unzipped
    #  and certain image files need to be converted too.
    #-------------------------------------------------------------
    case file.ext
    when '.ZIP'
      zipper = ImgUnzip.new
      zipper.unzip( file.path )
    when '.TIFF', '.TIF'
    when '.JPG', '.JPEG', '.GIF', '.PNG'
    else
    end
    
    render :text => "File has been uploaded to #{ file.path } successfully"
  end
end
