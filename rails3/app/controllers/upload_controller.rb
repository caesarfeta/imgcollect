class UploadController < ActionController::Base
  def index
    render :file => 'app/views/upload/form.haml'
  end
  def file
    if params['file'] == nil
      render :text => "No file uploaded"
      return
    end
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
    #  Not supported
    #-------------------------------------------------------------
    else
      render :text => "Filetype is not supported"
      return
    end
    #-------------------------------------------------------------
    #  Build the thumbnails
    #-------------------------------------------------------------
    report.each do |item|
      if item['path'] != nil && item['error'] == nil
        item['thumb'] = ImgThumb.create( item['path'] )
      end
    end
    
    puts report
    
    render :text => "File has been uploaded to #{ file.uploadPath } successfully"
  end
end
