class Image
  
  SINGLE = true
  MULTI = false
  
  REQUIRED = true
  
  # Constructor...
  # _url { String } The URL to the image
  def initialize( _url=nil )
    
    @prefixes = {
      :hmt => "<http://www.homermultitext.org/hmt/rdf/>", 
      :cite => "<http://www.homermultitext.org/cite/rdf/>",
      :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
      :crm => "<http://www.cidoc-crm.org/cidoc-crm/>",
      :dc => "<http://dublincore.org/documents/dces/>",
      :exif => "<http://www.kanzaki.com/ns/exif#>"
    }
    
    @attributes = {
      :path => [ "rdf:path", ::String, SINGLE, REQUIRED ],
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
    @template = "<urn:imgcollect:img.%>"
    @sparql = SparqlQuick.new( Rails.configuration.sparql_endpoint, @prefixes )
    
    #-------------------------------------------------------------
    #  If image URL is supplied get it
    #-------------------------------------------------------------
    if _url != nil
      get( _url )
    end
    
  end
  
  # _url { String } The URL to the image
  def get( _url )
    results = @sparql.select([ :s, pred( :path ), _url ])
    @urn = results[0][:s].to_s
    if @urn == nil
      raise "Record could not be found for #{ url }"
    end
  end
  
  # _values { Hash }
  def create( _values )
    new_urn()
    big_change( _values )
  end
  
  # _values { Hash }
  def big_change( _values )
    _values.each do | key, value |
      check = single_or_multi( key )
      case check
      when SINGLE
        change( key, value )
      when MULTI
        if value.class == ::Array
          value.each do | subval |
            add( key, subval )
          end
        else
          add( key, value )
        end
      end
    end
  end
  
  # Add a record
  # _key { Symbol }
  # _value { String, Other }
  def add( _key, _value )
    urn?()
    key = _key.to_sym
    attr?( key )
    type?( key )
    type_class?( key, _value )
    multi?( key )
    @sparql.insert([ @urn, pred( key ), _value ])
  end
  
  # Delete an attribute
  # _key { Symbol }
  # _value { String, Other }
  def delete( _key, _value=nil )
    urn?()
    key = _key.to_sym
    attr?( key )
    if _value == nil
      @sparql.delete([ @urn, pred( key ), :o ])
      return
    end
    @sparql.delete([ @urn, pred( key ), _value ])
  end
  
  # ActiveRecord style trickery
  def method_missing( _key, *_value )
    #-------------------------------------------------------------
    #  Get attribute object key
    #-------------------------------------------------------------
    key = /^[^\=]*/.match( _key ).to_s.to_sym
    #-------------------------------------------------------------
    #  Return current value if no value assigned
    #-------------------------------------------------------------
    value = _value[0]
    change( key, value )
  end
  
  private
  
  # Change an attribute
  # _key { Symbol }
  # _value { Array, String }
  def change( _key, _value )
    urn?()
    attr?( _key )
    if _value == nil
      return @sparql.value([ @urn, pred( _key ) ])
    end
    type?( _key )
    type_class?( _key, _value )
    single?( _key )
    #-------------------------------------------------------------
    #  Update the value
    #-------------------------------------------------------------
    @sparql.update([ @urn, pred( _key ), _value ])
  end
  
  # Does attribute key exist?
  # _key { Symbol } 
  def attr?( _key )
    if @attributes.has_key?( _key ) == false
      raise "Attribute #{ _key } not found."
    end
  end
  
  # _key { Symbol }
  def type?( _key )
    if @attributes[ _key ][1] == nil
      raise "Type not specified."
    end
  end
  
  # _key { Symbol }
  def pred( _key )
    p = @attributes[ _key ][0]
    if p == nil
      raise "Triple predicate not specified."
    end
    return p
  end
  
  # _key { Symbol }
  def single?( _key )
    check = single_or_multi( _key )
    if check != SINGLE
      raise "#{ _key } is not a SINGLE attribute. Use add( :#{ _key }, 'value' ) instead."
    end
  end
  
  # _key { Symbol }
  def multi?( _key )
    check = single_or_multi( _key )
    if check != MULTI
      raise "#{ _key } is not a MULTI attribute."
    end
  end
  
  def urn?
    if @urn == nil
      raise "Error @URN is null"
    end
  end
  
  # _key { Symbol }
  def single_or_multi( _key )
    return @attributes[ _key ][2]
  end
  
  def type_class?( _key, _value )
    type = @attributes[ _key ][1]
    check = _value.class
    if check != type
      raise "Type mismatch: \"#{ check }\" passed but  \"#{ type }\" is needed."
    end
  end
  
  # Get a new URN
  def new_urn
    index = @sparql.next_index([ pred( :path ), :o ], :s )
    @urn =  @template.sub( /%/, index.to_s )
  end
    
end
