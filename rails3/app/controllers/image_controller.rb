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
  
  def errorImg
    File.join( Rails.configuration.public_dir, 'img', 'img_not_found.png' )
  end
  
  #  Get an image preview
  def preview
    img = Image.new
    img.byId( params[:id] )
    @img = img.all
    render 'image/preview'
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
    cleanParams( params ).each do |key,val|
      img.add( key, val )
    end
    #-------------------------------------------------------------
    #  What will the output look like?
    #-------------------------------------------------------------
    render :text => 'Success'
  end
  
  #  TODO: Move this out of controller
  def cleanParams( _params )
    ignore = [ 'id', 'controller', 'action' ]
    clean = {}
    _params.each do |key,val|
      if ignore.include?( key ) == false
        clean[ key.to_sym ] = val
      end
    end
    clean
  end

  # Update image metadata
  def update
    img = Image.new
    img.byId( params[:id] )
    img.change( cleanParams( params ) )
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
        #  Update the image record exif metadata
        #-------------------------------------------------------------
        begin
          exif = ImgMeta.exif( item['path'] )
          image.change( exif );
        rescue
        end
      end
    end
    render :text => "File has been uploaded to #{ file.uploadPath } successfully"
  end
  
end
