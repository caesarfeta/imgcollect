class ImageController < ActionController::Base
  
  # TODO: Secure this sunnamabitch.
  def show
    #-------------------------------------------------------------
    #  TODO: Check the access restrictions on the file
    #-------------------------------------------------------------
    file = File.join( Rails.configuration.img_dir, params[:dir]+'.'+params[:format] )
    if File.exist?( file ) == false
      #-------------------------------------------------------------
      #  TODO: Return an error image and not an error message
      #-------------------------------------------------------------
      raise "File: #{file} could not be found"
    end
    send_file file, :disposition => 'inline'
  end
  
  def data
    img = Image.new
    img.byId( params[:id] )
    render :text => img.inspect
  end
  
  def upload
    #-------------------------------------------------------------
    #  If no form has been submitted
    #-------------------------------------------------------------
    if request.post? == false
      render :file => 'app/views/image/form.haml'
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
        #  Build the images
        #-------------------------------------------------------------
        item['thumb'] = ImgSize.thumb( item['path'] )
        item['basic'] = ImgSize.basic( item['path'] )
        item['advanced'] = ImgSize.advanced( item['path'] )
        #-------------------------------------------------------------
        #  Update the database with this new image
        #-------------------------------------------------------------
        image = Image.new
        image.create({ 
          :original => item['original'],
          :path => item['path'], 
          :thumb => item['thumb'], 
          :basic => item['basic'], 
          :advanced => item['advanced'] 
        })
      end
    end
    render :text => "File has been uploaded to #{ file.uploadPath } successfully"
  end
  
end
