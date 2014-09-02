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
  
  # Generate image previews
  # 
  # _urns { Array }
  def imgPreviews( _urns )
    this = []
    _urns.each do | urn |
      image = Image.new()
      image.byId( urn.just_i )
      this.push( imgSrc( image.thumb ) )
    end
    this
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
  
  # Create readable time output
  #
  # _time { Integer } 
  def readTime( _time )
    if _time.class.superclass != Integer
      return _time
    end
    time = Time.at( _time )
    return time.strftime( "%B %d, %Y -- %I:%M%p %Z" )
  end
  
  # Look up dimension size.
  #
  # _size { String }
  def dimensions( _size, _width, _height )
    _width = _width.to_f
    _height = _height.to_f
    sizes = { 
      :thumb => Rails.configuration.thumb_max_width,
      :basic => Rails.configuration.basic_max_width,
      :advanced => Rails.configuration.advanced_max_width,
      :path => _width
    };
    if sizes.has_key?( _size )
      coeff = _height.to_f/_width.to_f
      orig = sizes[_size].to_f
      width = (orig/_width)*_width
      height = width*coeff
      return "#{width.round} x #{height.round}"
    end
  end
  
end