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
end