class SparqlQuick
  
  def initialize( _endpoint, _prefixes=nil )
    @endpoint = _endpoint
    @prefixes = _prefixes
    #-------------------------------------------------------------
    #  Grab query and update handles
    #-------------------------------------------------------------
    @query = handle( 'query' )
    @update = handle( 'update' )
  end
  
  # _triple { Array }
  def insert( _triple )
    triple = uris( _triple )
    #-------------------------------------------------------------
    #  Insert the data
    #-------------------------------------------------------------
    @update.insert_data( RDF::Graph.new { |graph|
      graph << triple
    })
  end
  
  # _triple { Array }
  def select( _triple )
    triple = uris( _triple )
    #-------------------------------------------------------------
    #  Grab a SPARQL handle and run the query
    #-------------------------------------------------------------
    query = @query.select.where( triple )
    puts query
    #-------------------------------------------------------------
    #  Build the results object
    #-------------------------------------------------------------
    results=[]
    query.each_solution.each do | val |
      results.push( val.bindings )
    end
    return results
  end
  
  def deleteTriple( _s, _p, _o=nil )
  end
  
  # _type { String }
  # @return { SPARQL::Client }
  def handle( _type )
    return SPARQL::Client.new( File.join( @endpoint, _type ) )
  end
  
  # Build URIs
  def uris( _triple )
    triple=[]
    _triple.each do | val |
      triple.push( uri( val ) )
    end
    return triple
  end
  
  # Should this be turned into a URI?
  def uri( _val )
    #-------------------------------------------------------------
    #  If it's a symbol get out of there.
    #-------------------------------------------------------------
    if _val.class == ::Symbol
      return _val
    end
    #-------------------------------------------------------------
    #  Are you a URI or a literal?
    #-------------------------------------------------------------
    if _val.class == ::String
      #-------------------------------------------------------------
      #  URI with no prefix
      #-------------------------------------------------------------
      first = _val[0]
      last = _val[-1,1]
      if first == "<" && last == ">"
        return RDF::URI( clip( _val ) )
      end
      #-------------------------------------------------------------
      #  With prefix
      #-------------------------------------------------------------
      if @prefixes != nil
        pre, colon, last = _val.rpartition(':')
        pre = pre.to_sym
        if @prefixes.has_key?( pre )
          return uri( "<"+clip( @prefixes[ pre ] )+last+">" )
        end
      end
    end
    return RDF::Literal( _val )
  end
  
  private
  
  # Clip the arrows from the edges of an RDF URI string
  def clip( _val )
    val = String.new( _val )
    val[0]=''
    val[-1]=''
    return val
  end
  
end