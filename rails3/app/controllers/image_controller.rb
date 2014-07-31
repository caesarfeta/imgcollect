class ImageController < ActionController::Base
  
  #  Display an image
  # TODO: Secure this sunnamabitch.
  def show
    if params[:dir] == nil || params[:format] == nil
      send_file errorImg, :disposition => 'inline'
      return
    end
    file = File.join( Rails.configuration.img_dir, params[:dir]+'.'+params[:format] )
    #-------------------------------------------------------------
    #  If file isn't found return the 'IMAGE NOT FOUND' image
    #-------------------------------------------------------------
    if File.exist?( file ) == false
      send_file errorImg, :disposition => 'inline'
      return
    end
    send_file file, :disposition => 'inline'
  end
  
  # Get the error image
  def errorImg
    File.join( Rails.configuration.public_dir, 'img', 'img_not_found.png' )
  end
  
  # Get a full image report
  def full
    img = Image.new
    img.byId( params[:id] )
    @img = img.all
    render 'image/full'
  end
  
  # Add image metadata
  def add
    img = Image.new
    img.byId( params[:id] )
    ControllerHelper.cleanParams( params ).each do |key,val|
      img.add( key, val )
    end
    #-------------------------------------------------------------
    #  What will the output look like?
    #-------------------------------------------------------------
    render :text => 'Success'
  end
  
  # Update image metadata
  def update
    img = Image.new
    img.byId( params[:id] )
    vals = ControllerHelper.cleanParams( params )
    img.change( vals )
    render :text => 'Success'
  end
  
  # Upload an image
  def upload
    #-------------------------------------------------------------
    #  If no form has been submitted
    #-------------------------------------------------------------
    if request.post? == false
      render :file => 'app/views/image/upload.haml'
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
    #  What will become the JSON return
    #-------------------------------------------------------------
    json = []
    #-------------------------------------------------------------
    #  Resize the image & save it in the triplestore
    #-------------------------------------------------------------
    report.each do |item|
      if item['path'] != nil && item['error'] == nil
        #-------------------------------------------------------------
        #  Build the images
        #-------------------------------------------------------------
        item['thumb'] = ImgSize.thumb( item['path'] )
        item['basic'] = ImgSize.basic( item['path'] )
        item['advanced'] = ImgSize.advanced( item['path'] )
        #-------------------------------------------------------------
        #  Create an image record in the triplestore
        #-------------------------------------------------------------
        image = Image.new
        image.create({ 
          :original => item['original'],
          :path => item['path'], 
          :thumb => item['thumb'], 
          :basic => item['basic'], 
          :advanced => item['advanced'] 
        })
        #-------------------------------------------------------------
        #  Get the original dimensions
        #-------------------------------------------------------------
        size = FastImage.size( item['path'] )
        image.change({
          :width => size[0],
          :height => size[1]
        })
        #-------------------------------------------------------------
        #  Update the image record exif metadata
        #-------------------------------------------------------------
        begin
          exif = ImgMeta.exif( item['path'] )
          image.change( exif );
        rescue
          #-------------------------------------------------------------
          #  No exif data is no big deal... Just move on.
          #-------------------------------------------------------------
        end
        json.push({ :message => "Success", :urn => image.urn })
      end
    end
    render :json => json
  end
  
end
