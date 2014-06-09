class SparqlQuick
  
  # _endpoint { String }
  # _prefixes { Hash }
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
    @update.insert_data( RDF::Graph.new { | graph |
      graph << triple
    })
  end
  
  # _triple { Array }
  def update( _triple )
    toDelete = _triple.clone
    toDelete[2] = :o
    results = select( toDelete )
    if results.length > 1
      raise "Can only update one triple at a time.  Multiple triples returned during check"
    end
    delete( toDelete )
    insert( _triple )
  end
  
  # _triple { Array }
  def delete( _triple )
    #-------------------------------------------------------------
    #  Check to see what you're deleting
    #-------------------------------------------------------------
    results = select( _triple )
    #-------------------------------------------------------------
    # SPARQL::Client.delete_data can only a complete s,p,o triple
    # So we have to fill in the details.  See destroy()
    #-------------------------------------------------------------
    results.each do | hash |
      toDelete = _triple.clone
      hash.keys.each do | key |
        case key
          when :s
            toDelete[0] = hash[key]
          when :p
            toDelete[1] = hash[key]
          when :o
            toDelete[2] = hash[key]
        end
        destroy( toDelete )
      end
    end
  end
  
  # _triple { Array }
  def select( _triple )
    triple = uris( _triple )
    #-------------------------------------------------------------
    #  Grab a SPARQL handle and run the query
    #-------------------------------------------------------------
    query = @query.select.where( triple )
    #-------------------------------------------------------------
    #  Build the results object
    #-------------------------------------------------------------
    results=[]
    query.each_solution.each do | val |
      results.push( val.bindings )
    end
    return results
  end
  
  # _type { String }
  # @return { SPARQL::Client }
  def handle( _type )
    return SPARQL::Client.new( File.join( @endpoint, _type ) )
  end
  
  # Build URIs
  # _triple { Array }
  def uris( _triple )
    triple=[]
    _triple.each do | val |
      triple.push( uri( val ) )
    end
    return triple
  end
  
  # Should this be turned into a URI?
  # _val { String, Symbol, Other... }
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
  
  # Remove a triple for real...
  # _triple { Array }
  def destroy( _triple )
    triple = uris( _triple )
    @update.delete_data( RDF::Graph.new { | graph |
      graph << triple
    })
  end
  
  # Clip the arrows from the edges of an RDF URI string
  def clip( _val )
    val = String.new( _val )
    val[0]=''
    val[-1]=''
    return val
  end
  
end