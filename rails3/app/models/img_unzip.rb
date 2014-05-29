require 'zip'
class ImgUnzip
  
  def initialize
    @ok = [ '.PNG', '.GIF', '.JPG', '.JPEG', '.TIFF', '.TIF' ]
  end
  
  # _file { String }
  def unzip( _file )
    @dir = UploadUtils.monthDir( Rails.configuration.img_dir )
    Zip::File.open( _file ) do |zip|
      zip.each do |entry|
        check( entry )
      end
    end
  end
  
  # _entry { Zip::Entry }
  def check( _entry )
    if _entry.directory?
      return
    end
    path = _entry.name
    #-------------------------------------------------------------
    #  Check to see if filetype is supported
    #-------------------------------------------------------------
    ext = File.extname( path ).upcase
    if @ok.include?( ext ) == false
      # TODO: Throw an error, report or something
      return
    end
    file = File.basename( _entry.name )
    path = File.join( @dir, file )
    #-------------------------------------------------------------
    #  Extract the file to a unique location
    #-------------------------------------------------------------
    res = UploadUtils.filename( path )
    _entry.extract( res['path'] )
  end
  
end