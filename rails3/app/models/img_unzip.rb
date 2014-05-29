require 'zip'
class ImgUnzip
  
  def initialize
    @ok = [ '.PNG', '.GIF', '.JPG', '.JPEG', '.TIFF', '.TIF' ]
    @report = []
    #-------------------------------------------------------------
    #  Common errors
    #-------------------------------------------------------------
    @errorFiletype = 'Filetype is not supported. Supported types are ' + @ok.join(', ')
    @errorDot = 'Dot files ( files beginning with a period ) are ignored'
    @errorDir = 'Directories are ignored'
  end
  
  # _file { String }
  # @return { Array } @report The full unzip report
  def unzip( _file )
    @dir = UploadUtils.monthDir( Rails.configuration.img_dir )
    Zip::File.open( _file ) do |zip|
      zip.each do |entry|
        @report.push( check( entry ) )
      end
    end
    return @report
  end
  
  private
  # _entry { Zip::Entry }
  # @return { Hash } A report entry
  def check( _entry )
    #-------------------------------------------------------------
    #  If it's a directory exit
    #-------------------------------------------------------------
    if _entry.directory?
      return item( _entry.name, nil, @errorDir )
    end
    path = _entry.name
    #-------------------------------------------------------------
    #  Check to see if filetype is supported
    #-------------------------------------------------------------
    ext = File.extname( path ).upcase
    if @ok.include?( ext ) == false
      return item( _entry.name, nil, @errorFiletype )
    end
    file = File.basename( _entry.name )
    #-------------------------------------------------------------
    #  Ignore dot files
    #-------------------------------------------------------------
    if file[0,1] == '.'
      return item( _entry.name, nil, @errorDot )
    end
    path = File.join( @dir, file )
    #-------------------------------------------------------------
    #  Extract the file to a unique location
    #-------------------------------------------------------------
    res = UploadUtils.filename( path )
    _entry.extract( res['path'] )
    return item( _entry.name, res['path'], nil )
  end
  
  # _original { String }
  # _path { String }
  # _error { String }
  # @return { Hash } A report entry
  def item( _original, _path, _error )
    return { 'original' => _original, 'path' => _path, 'error' => _error }
  end
end