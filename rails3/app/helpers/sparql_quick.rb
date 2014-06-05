class SparqlQuick
  
  # _triple { Array }
  def insert( _triple )
    triple = uris( _triple )
    sparql = self.handle( 'update' )
    #-------------------------------------------------------------
    #  Insert the data
    #-------------------------------------------------------------
    sparql.insert_data( RDF::Graph.new { |graph|
      graph << triple
    })
  end
  
  # _triple { Array }
  def select( _triple )
    triple = uris( _triple )
    #-------------------------------------------------------------
    #  Grab a SPARQL handle and run the query
    #-------------------------------------------------------------
    sparql = handle( 'query' )
    query = sparql.select.where( triple )
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
#    return SPARQL::Client.new( Rails.configuration.sparql_endpoint+'/'+_type )
    return SPARQL::Client.new( 'http://localhost:8080/ds'+'/'+_type )
  end
  
  # Build URIs
  def uris( _triple )
    triple=[]
    _triple.each do | val |
      if val.class == ::String
        val = uri( val )
      end
      triple.push( val )
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
      first = _val[0]
      last = _val[-1,1]
      if first == "<" && last == ">"
        _val[0]=''
        _val[-1]=''
        return RDF::URI( _val )
      end
    end
    return RDF::Literal( _val )
  end
  
end