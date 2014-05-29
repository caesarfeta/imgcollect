class UploadController < ActionController::Base
  def index
    render :file => 'app/views/upload/form.haml'
  end
  def file
    #-------------------------------------------------------------
    #  Save the file
    #-------------------------------------------------------------
    file = ImgUpload.new
    file.save( params )
    #-------------------------------------------------------------
    #  Check the file type because zip files need to be unzipped
    #  and certain image files need to be converted too.
    #-------------------------------------------------------------
    report = Array.new
    case file.ext
    when '.ZIP'
      zipper = ImgUnzip.new
      report = zipper.unzip( file.uploadPath )
    when '.JPG', '.JPEG', '.GIF', '.PNG', '.TIFF', '.TIF'
      #-------------------------------------------------------------
      #  Save file to images directory
      #-------------------------------------------------------------
      report.push( file.toImgDir )
    #-------------------------------------------------------------
    #  File type is not supported...
    #-------------------------------------------------------------
    else
    end
    #-------------------------------------------------------------
    #  Build the thumbnails
    #-------------------------------------------------------------
    puts report
    
    render :text => "File has been uploaded to #{ file.uploadPath } successfully"
  end
end
