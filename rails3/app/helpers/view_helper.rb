module ViewHelper
  
  def count( _obj )
    if _obj.class == Array
      return _obj.count
    end
    return 0
  end
  
  def readTime( _time )
    return Time.at( _time )
  end
  
  def imgSrc( _url )
    if _url.index( Rails.configuration.img_dir ) == nil
      return _url
    end
    path = _url.sub( Rails.configuration.img_dir, '' )
    "/image/show#{path}"
  end
  
end