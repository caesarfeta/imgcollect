#-------------------------------------------------------------
#  Prefix
#-------------------------------------------------------------
class Fuseki::Prefix
  def initialize
    @list = Hash.new
  end
  
  def add( _key, _val )
    #-------------------------------------------------------------
    #  TODO: Make sure key and val are valid
    #-------------------------------------------------------------
    @list[ _key ] = _val
  end
  
  def delete( _key )
    @list.delete( _key )
  end
  
  def sparql
    output = ''
    @list.each do |key, val|
      output += "PREFIX #{key}: <#{val}>\n"
    end
    return output
  end
  
end