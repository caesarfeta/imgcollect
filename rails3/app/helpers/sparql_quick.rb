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
  
  # Insert a single triple
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
  
  # Update a single triple
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
  
  # Delete a triple or partial triple
  # _triple { Array }
  def delete( _triple )
    #-------------------------------------------------------------
    #  Safety check
    #-------------------------------------------------------------
    check_count = 0
    _triple.each do | check |
      if check.class == ::Symbol
        check_count += 1
      end
    end
    if check_count == 3
      raise "Did you really want to delete entire database? Argument must contain one URI or literal value."
    end
    if check_count == 0
      destroy( _triple )
    end
    #-------------------------------------------------------------
    #  Check to see what you're deleting
    #-------------------------------------------------------------
    results = select( _triple )
    #-------------------------------------------------------------
    # SPARQL::Client.delete_data can only delete a complete
    # s,p,o triple.  So we have to fill in the details.
    #-------------------------------------------------------------
    puts results
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
  # @return { Array }
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
  
  # _double { Array }
  # @return { Array, String }
  def value( _double )
    results = get_objects( _double )
    if results.length == 0
      return nil
    end
    #-------------------------------------------------------------
    #  Get the values
    #-------------------------------------------------------------
    out = []
    results.each do | val |
      out.push( val[:o].to_s )
    end
    #-------------------------------------------------------------
    #  If only a single value is returned don't return
    #  an array with one element in it.
    #-------------------------------------------------------------
    if out.length == 1
      return out[0]
    end
    #-------------------------------------------------------------
    #  Return an array
    #-------------------------------------------------------------
    return out
  end
  
  # _type { String }
  # @return { SPARQL::Client }
  def handle( _type )
    return SPARQL::Client.new( File.join( @endpoint, _type ) )
  end

  # Get the next index
  # _double { Array }
  # _side { Symbol }
  # @return { Fixnum }
  def next_index( _double, _side=:o )
    #-------------------------------------------------------------
    #  Where's the indexed URNs?
    #-------------------------------------------------------------
    results = nil
    case _side
    when :o
      results = get_objects( _double )
    when :s
      results = get_subjects( _double )
    end
    if results == nil
      raise "Indexed URNs not found"
    end
    #-------------------------------------------------------------
    #  Get the indices
    #-------------------------------------------------------------
    ns = []
    results.each do | val |
      string = val[ _side ].to_s
      n = string[-1,1]
      ns.push( n.to_i )
    end
    #-------------------------------------------------------------
    #  Sort them
    #-------------------------------------------------------------
    ns = ns.sort
    return ns[ ns.length-1 ]+1
  end
  
  # Build URIs
  # _triple { Array }
  # @return { Array } 
  def uris( _triple )
    triple=[]
    _triple.each do | val |
      triple.push( uri( val ) )
    end
    return triple
  end
  
  # Should this be turned into a URI?
  # _val { String, Symbol, etc... }
  # _return { RDF::URI, RDF::Literal, Symbol }
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
        return RDF::URI( _val.clip )
      end
      #-------------------------------------------------------------
      #  With prefix
      #-------------------------------------------------------------
      if @prefixes != nil
        pre, colon, last = _val.rpartition(':')
        pre = pre.to_sym
        if @prefixes.has_key?( pre )
          return uri( "<"+@prefixes[ pre ].clip+last+">" )
        end
      end
    end
    return RDF::Literal( _val )
  end
  
  
  
  
  
  private
  
  # _double { Array }
  # @return { Array }
  def get_objects( _double )
    triple = _double.clone
    triple[2] = :o
    return select( triple )
  end
  
  # _double { Array }
  # @return { Array }
  def get_subjects( _double )
    triple = _double.clone
    triple.unshift( :s )
    return select( triple )
  end
  
  # Remove a triple for real...
  # _triple { Array }
  def destroy( _triple )
    triple = uris( _triple )
    @update.delete_data( RDF::Graph.new { | graph |
      graph << triple
    })
  end
  
end

class String
  
  # Clip the first and last characters from a string
  # @return { String }
  def clip
    val = String.new( self )
    val[0]=''
    val[-1]=''
    return val
  end
end