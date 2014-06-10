class Image
  SINGLE = true
  MULTI = false
  PREFIXES = {
    :hmt => "<http://www.homermultitext.org/hmt/rdf/>", 
    :cite => "<http://www.homermultitext.org/cite/rdf/>",
    :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
    :crm => "<http://www.cidoc-crm.org/cidoc-crm/>",
    :dc => "<http://dublincore.org/documents/dces/>",
    :exif => "<http://www.kanzaki.com/ns/exif#>"
  }
  
  # Constructor...
  # _url { String } The URL to the image
  def initialize( _url=nil )
    host = 'http://localhost:8080/ds'
    @attributes = {
      :path => [ "rdf:path", ::String, SINGLE ],
      :keywords => [ "rdf:keywords", ::String, MULTI ],
      :image_descrption => [ "exif:imageDescription",  ::String, SINGLE ],
      :make => [ "exif:make",  ::String, SINGLE ],
      :model => [ "exif:model", ::String, SINGLE ],
      :orientation => [ "exif:orientation", ::String, SINGLE ],
      :x_resolution => [ "exif:xResolution", ::String, SINGLE ],
      :y_resolution => [ "exif:yResolution", ::String, SINGLE ],
      :resolution_unit => [ "exif:resolutionUnit", ::String, SINGLE ],
      :software => [ "exif:software", ::String, SINGLE ],
      :date_time => [ "exif:dateTime", ::String, SINGLE ],
      :ycb_cr_positioning => [ "exif:ycbCrPositioning", ::String, SINGLE ],
      :exposure_time => [ "exif:exposureTime", ::String, SINGLE ],
      :f_number => [ "exif:fNumber", ::String, SINGLE ],
      :exposure_program => [ "exif:exposureProgram", ::String, SINGLE ],
      :iso_speed_ratings => [ "exif:isoSpeedRatings", ::String, SINGLE ],
      :date_time_original => [ "exif:dateTimeOriginal", ::String, SINGLE ],
      :date_time_digitized => [ "exif:dateTimeDigitized", ::String, SINGLE ],
      :compressed_bits_per_pixel => [ "exif:compressedBitsPerPixel", ::String, SINGLE ],
      :brightness_value => [ "exif:brightnessValue", ::String, SINGLE ],
      :exposure_bias_value => [ "exif:exposureBiasValue", ::String, SINGLE ],
      :max_aperture_value => [ "exif:maxApertureValue", ::String, SINGLE ],
      :metering_mode => [ "exif:meteringMode", ::String, SINGLE ],
      :light_source => [ "exif:lightSource", ::String, SINGLE ],
      :flash => [ "exif:flash", ::String, SINGLE ],
      :focal_length => [ "exif:focalLength", ::String, SINGLE ],
      :user_comment => [ "exif:userComment", ::String, SINGLE ],
      :color_space => [ "exif:colorSpace", ::String, SINGLE ],
      :pixel_x_dimension => [ "exif:pixelXDimension", ::String, SINGLE ],
      :pixel_y_dimension => [ "exif:pixelYDimension", ::String, SINGLE ],
      :custom_rendered => [ "exif:customRendered", ::String, SINGLE ],
      :exposure_mode => [ "exif:exposureMode", ::String, SINGLE ],
      :white_balance => [ "exif:whiteBalance", ::String, SINGLE ],
      :focal_length_in_35mm_film => [ "exif:focalLengthIn35mmFilm", ::String, SINGLE ],
      :scene_capture_type => [ "exif:sceneCaptureType", ::String, SINGLE ],
      :contrast => [ "exif:contrast", ::String, SINGLE ],
      :saturation => [ "exif:saturation", ::String, SINGLE ],
      :sharpness => [ "exif:sharpness", ::String, SINGLE ],
      :image_unique_id => [ "exif:imageUniqueId", ::String, SINGLE ]
    }
    @sparql = SparqlQuick.new( host, PREFIXES )
    #-------------------------------------------------------------
    #  If image URL is supplied get it
    #-------------------------------------------------------------
    if _url != nil
      get( _url )
    end
    @urn = "<urn:imgcollect:img.1>"
  end
  
  # _url { String } The URL to the image
  def get( _url )
  end
  
  # _attr { Hash }
  def create( _attr )
  end
  
  def add( _key, _value )
    key = _key.to_sym
    attr?( key )
    type?( key )
    type_class?( key, _value )
    multi?( key )
    @sparql.insert([ @urn, pred( key ), _value ])
  end
  
  # Check for attributes
  def method_missing( _attr, *_value, &_block )
    #-------------------------------------------------------------
    #  Get attribute object key
    #-------------------------------------------------------------
    key = /^[^\=]*/.match( _attr ).to_s.to_sym
    attr?( key )
    #-------------------------------------------------------------
    #  Return current value if no value assigned
    #-------------------------------------------------------------
    value = _value[0]
    if value == nil
      return @sparql.value([ @urn, pred( key ) ])
    end
    type?( key )
    type_class?( key, value )
    single?( key )
    #-------------------------------------------------------------
    #  Update the value
    #-------------------------------------------------------------
    @sparql.update([ @urn, pred( key ), value ])
  end
  
  private
  
  # _key { Symbol } Does attribute key exist?
  def attr?( _key )
    if @attributes.has_key?( _key ) == false
      raise "Attribute #{ _key } not found."
    end
  end
  
  def type?( _key )
    if @attributes[ _key ][1] == nil
      raise "Type not specified."
    end
  end
  
  def pred( _key )
    p = @attributes[ _key ][0]
    if p == nil
      raise "Triple predicate not specified."
    end
    return p
  end
  
  def single?( _key )
    check = @attributes[ _key ][2]
    if check != SINGLE
      raise "#{ _key } is not a SINGLE attribute. Use add( :#{ _key }, 'value' ) instead."
    end
  end
  
  def multi?( _key )
    check = @attributes[ _key ][2]
    if check != MULTI
      raise "#{ _key } is not a MULTI attribute."
    end
  end
  
  def type_class?( _key, _value )
    type = @attributes[ _key ][1]
    check = _value.class
    if check != type
      raise "Type mismatch: \"#{ check }\" passed but  \"#{ type }\" is needed."
    end
  end
    
end
