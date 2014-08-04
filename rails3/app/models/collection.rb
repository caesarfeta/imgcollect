require_relative "../../../../sparql_model/lib/sparql_model.rb"
class Collection < SparqlModel

  def initialize( _key=nil )
    @endpoint =  Rails.configuration.sparql_endpoint
    @attributes = {
      :name => [ "this:name", ::String, SINGLE, REQUIRED, UNIQUE, KEY ],
      :cite_urn => [ "this:cite_urn", ::RDF::URI, SINGLE, REQUIRED, UNIQUE ],
      :keywords => [ "this:keywords", ::String, MULTI ],
      :images => [ "this:images", ::RDF::URI, MULTI ],
      :subcollections => [ "this:subcollections", ::RDF::URI, MULTI ]
    }
    super( _key )
  end
  
end
