#-------------------------------------------------------------
#  Fuseki::Update
#
#  fuseki = Fuseki::Update.new( 'http://localhost:8080/ds/update')

#  // Add a prefix
#  fuseki.prefix.add( 'dc', 'http://purl.org/dc/elements/1.1/' )
#  fuseki.prefix.inspect

#  // Insert values
#  fuseki.add( 'http://example/book1', { 'dc:title' => 'value', 'dc:author' => 'value1' } )
#
#-------------------------------------------------------------
class Fuseki::Update
  #-------------------------------------------------------------
  #  Public methods
  #-------------------------------------------------------------
  def initialize( _url )
    @url = _url
    @prefix = Fuseki::Prefix.new
  end
  
  #-------------------------------------------------------------
  #  prefix getter
  #-------------------------------------------------------------
  def prefix
    @prefix
  end
  
  #-------------------------------------------------------------
  #  Add a triple
  #-------------------------------------------------------------
  def add( _sub, _po )
    send( insertData( _sub, _po ) )
  end
  
  #-------------------------------------------------------------
  #  Private methods
  #-------------------------------------------------------------
  private
  
  #-------------------------------------------------------------
  #  Return a SPARQL INSERT DATA statement
  #-------------------------------------------------------------
  def insertData( _sub, _po )
    return %Q(
      #{@prefix.sparql}
      INSERT DATA {
        <#{_sub}> #{sparql(_po)}
      }
    )
  end

  #-------------------------------------------------------------
  #  Check the predicates and objects
  #-------------------------------------------------------------  
  def sparql( _po )
    output = ""
    i = 0;
    _po.each do |key, val|
      #-------------------------------------------------------------
      #  TODO: Check the key prefixes
      #-------------------------------------------------------------
      output += "#{key} \"#{val}\""
      if i == 0
        output += ";"
      else
        output += "."
      end
      output += "\n"
      i += 1
    end
    puts output
    return output
  end
  
  #-------------------------------------------------------------
  #  Send the query to the Fuseki server
  #-------------------------------------------------------------
  def send( _query )
    response = Net::HTTPSession.post_form( URI( @url ), 'update' => _query )
    puts response
  end
  
end