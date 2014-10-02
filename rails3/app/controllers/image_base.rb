class ImageBase < ActionController::Base
  
  def returnFile( _file )
    send_file _file, :disposition => 'inline'
  end
  
  # The error image
  def errorImg
    File.join( Rails.configuration.public_dir, 'img', 'img_not_found.png' )
  end
  
  # Image not found
  def imgNotFound( _file )
    if File.exist?( _file ) == false
      send_file errorImg, :disposition => 'inline'
      return
    end
  end
  
  def imgProcessing
    send_file processImg, :disposition => 'inline'
    return
  end
  
  def processImg
    File.join( Rails.configuration.public_dir, 'img', 'img_processing.png' )
  end
  
end