require_relative "../../../../sparql_model/lib/sparql_model.rb"
class Collection < SparqlModel

  def initialize( _key=nil )
    @endpoint =  Rails.configuration.sparql_endpoint
    @model = "<urn:img_collect:collection>"
    @prefixes = {
      :this => "<http://localhost/img_collect/collection#>"
    }
    @attributes = {
      :name => [ "this:name", ::String, SINGLE, REQUIRED, UNIQUE, KEY ],
      :nickname => [ "this:nickanme", ::String, SINGLE, REQUIRED ],
      :keywords => [ "this:keywords", ::String, MULTI ],
      :images => [ "this:images", ::String, MULTI ],
      :subcollections => [ "this:subcollections", ::String, MULTI ]
    }
    super( _key )
  end
  
end
