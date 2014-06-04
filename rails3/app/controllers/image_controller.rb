class ImageController < ActionController::Base
  
  # TODO: Secure this sunnamabitch.
  def show
    file = File.join( Rails.configuration.img_dir, params[:dir]+'.'+params[:format] )
    if File.exist?( file ) == false
      raise "File: #{file} could not be found"
    end
    send_file file, :disposition => 'inline'
  end
  
  # Display upload form
  def form
    render :file => 'app/views/image/form.haml'
  end
  
  # The backside of upload()
  def upload
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
    report.each do |item|
      if item['path'] != nil && item['error'] == nil
        #-------------------------------------------------------------
        #  Build the thumbnails
        #-------------------------------------------------------------
        item['thumb'] = ImgThumb.create( item['path'] )
        #-------------------------------------------------------------
        #  Update the database with this new image
        #-------------------------------------------------------------
        image = Image.new
        image.update_attributes({ 'path' => item['path'], 'original' => item['original'], 'thumb' => item['thumb'] })
      end
    end
    render :text => "File has been uploaded to #{ file.uploadPath } successfully"
  end
  
end
