module ViewHelper
  
  # Count the number of objects in an Array
  #
  # _obj { Array, ??? }
  def count( _obj )
    if _obj.class == Array
      return _obj.count
    end
    return 0
  end
  
  # Create readable time output
  #
  # _time { Integer } 
  def readTime( _time )
    # return Time.at( _time )
    time = Time.at( _time )
    return time.strftime( "%A %B %d, %Y %I:%M%p %Z" )
  end
  
  # If image is stored locally build the url to the image/show method
  # 
  # _url { String } Image url
  def imgSrc( _url )
    #-------------------------------------------------------------
    #  Processed Image directory?
    #-------------------------------------------------------------
    if _url.index( Rails.configuration.img_dir ) != nil
      path = _url.sub( Rails.configuration.img_dir, '' )
      return "/image/show#{path}"
    end
    _url
  end
  
  # Turn a key into a label
  # 
  # _text { String, ??? } The key
  def labelify( _text )
    text = _text.to_s.gsub!( '_', ' ' )
    if text == nil
      text = _text
    end
    text
  end
  
  # Look up dimension size.
  #
  # _size { String }
  def dimensions( _size )
    sizes = { 
      :thumb => Rails.configuration.thumb_max_width,
      :basic => Rails.configuration.basic_max_width,
      :advanced => Rails.configuration.advanced_max_width
    };
    if sizes.has_key?( _size )
      return "- #{sizes[_size]}"
    end
    ''
  end
  
end