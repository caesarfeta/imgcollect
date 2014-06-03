class Collection
  # c = Collection.new
  # c.create( { 'name' => 'dbl', 'fullname' => 'Decibels', 'label' => 'Meteors' } )
  # c.get( 'dbl' )
  # 
  # Queries:
  # All collections 
  #   name, summary, image count
  
  # Collection
  #   images in sequence
  #
  #
  # The larger problem to solve is getting the triples into a ruby datastructure

  def initialize
    @prefix = { 
      'hmt' => 'http://www.homermultitext.org/hmt/rdf/',
      'cite' => 'http://www.homermultitext.org/cite/rdf/',
      'rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      'crm' => 'http://www.cidoc-crm.org/cidoc-crm'
     }
  end
  
  # _param { Hash }
  #    _param['name'] { String }
  #    _param['fullname'] { String }
  #    _param['label'] { String }
  def create( _param )
    @name = _param['name']
    @fullname = _param['fullname']
    @label = _param['label']
    #-------------------------------------------------------------
    #  Make sure name is unique
    #-------------------------------------------------------------
    insertTriple( citeUrn( @name ), "#{@prefix['rdf']}type", RDF::URI( "#{@prefix['cite']}ImageArchive" ) )
    insertTriple( citeUrn( @name ), "#{@prefix['rdf']}label", RDF::Literal( @label ) )
  end
  
  # _name { String }
  def get( _name )
    @name = _name
    results = select( citeUrn( @name ) )
    # TODO: Check results
    results.each do | result |
      puts result.to_hash()
    end
  end
  
  # _name { String }
  def selectImgs( _name=nil )
    if ( _name != nil )
      @name = _name
    end
    results = select( citeUrn( @name ), "#{@prefix['cite']}possesses" )
    ns = Array.new
    results.each do | result |
      id = result.to_hash()[:o].to_str
      n = id.sub( "urn:cite:perseus:#{@name}.", "" )
      n = n.to_i
      ns.push( n )
    end
    @imgs = ns.sort
  end
  
  # _name { String }
  def imgsCount( _name=nil )
    if ( _name != nil )
      @name = _name
    end
    return count( citeUrn( @name ), "#{@prefix['cite']}possesses" )
  end
  
  # _url { String }
  def addImg( _url )
    #-------------------------------------------------------------
    #  Make sure an existing collection is loaded
    #-------------------------------------------------------------
    raise "Missing name" if @name.nil?
    id = nextImgId()
    collection = citeUrn( @name )
    img = RDF::URI( collection + "." + id )
    #-------------------------------------------------------------
    #  Create img URI
    #-------------------------------------------------------------
    insertTriple( img, "#{@prefix['hmt']}path", _url )
    #-------------------------------------------------------------
    #  Add img URI to collection
    #-------------------------------------------------------------
    insertTriple( collection, "#{@prefix['cite']}possesses", img )
  end
  
  # _name { String }
  def citeUrn( _name )
    return "urn:cite:perseus:#{_name}"
  end

  #  _s { String }
  #  _p { String }
  #  _o { String, RDF::URI, RDF::Literal }
  def insertTriple( _s, _p, _o )
    s = RDF::URI( _s )
    p = RDF::URI( _p )
    sparql = handle( 'update' )
    sparql.insert_data( RDF::Graph.new { |graph|
      graph << [ s, p, _o ]
    })
  end
  
  # Retrieve a collection's the next image id
  # Useful for when inserting a new
  # @return { String }
  def nextImgId()
    id = lastImgId
    if id == nil
      id = 0
    end
    id += 1
    return id.to_s
  end
  
  def lastImgId
    selectImgs()
    return @imgs[ @imgs.count - 1 ]
  end
  
  #  _s { String }
  #  _p { String }
  def select( _s, _p=nil )
    s = RDF::URI( _s )
    sparql = handle( 'query' )
    if _p != nil
      p = RDF::URI( _p )
      query = sparql.select.where([s, p, :o])
    else
      query = sparql.select.where([s, :p, :o])
    end
    return query.each_solution
  end
  
  # Retrieve all collections URNs
  def all
    sparql = handle( 'query' )
    p = RDF::URI( "#{@prefix['rdf']}type" )
    o = RDF::URI( "#{@prefix['cite']}ImageArchive" )
    query = sparql.select.where([:s, p, o])
    urns = []
    query.each_solution do | solution |
      solution.each_value do | value |
        urns.push( value )
      end
    end
    return urns
  end
  
  def allSummary
    sparql = handle( 'query' )
    urns = all()
    urns.each do | urn |
      query = sparql.select.where([urn, :p, :o])
      query.each_solution do | solution |
        solution.each_binding do | key, value |
          puts key
          puts value
        end
      end
    end
  end
  
  #  _s { String }
  #  _p { String }
  # @return { Fixnum }
  def count( _s, _p=nil )
    s = RDF::URI( _s )
    sparql = handle( 'query' )
    if _p != nil
      p = RDF::URI( _p )
      count = sparql.select.where([s, p, :o]).count()
    else
      count = sparql.select.where([s, :p, :o]).count()
    end
    return count
  end
  
  def deleteTriple( _s, _p, _o=nil )
  end
  
  # _type { String }
  # @return { SPARQL::Client }
  def handle( _type )
    return SPARQL::Client.new( Rails.configuration.sparql_endpoint+'/'+_type )
  end

end