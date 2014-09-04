class Collection < SparqlModel

  def initialize( _key=nil )
    @endpoint =  Rails.configuration.sparql_endpoint
    @prefixes = {
      :rdf => "<http://www.w3.org/1999/02/22-rdf-syntax-ns#>"
    }
    @attributes = {
      :name => [ "this:name", ::String, SINGLE, REQUIRED, UNIQUE, KEY ],
      :cite_urn => [ "this:cite_urn", ::URN, SINGLE, OPTIONAL, UNIQUE ],
      :user => [ "this:user", ::URN, SINGLE, REQUIRED ],
      :label => [ "rdf:label", ::String, SINGLE, REQUIRED ],
      :keywords => [ "this:keywords", ::String, MULTI ],
      :images => [ "this:images", ::String, MULTI ],
      :subcollections => [ "this:subcollections", ::String, MULTI ]
    }
    super( _key )
  end
  
end
