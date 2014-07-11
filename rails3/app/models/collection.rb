require_relative "../../../../sparql_model/lib/sparql_model.rb"
class Collection < SparqlModel

  def initialize( _key=nil )
    @endpoint =  Rails.configuration.sparql_endpoint
    @attributes = {
      :name => [ "this:name", ::String, SINGLE, REQUIRED, UNIQUE, KEY ],
      :nickname => [ "this:nickname", ::String, SINGLE, REQUIRED ],
      :keywords => [ "this:keywords", ::String, MULTI ],
      :images => [ "this:images", ::String, MULTI ],
      :subcollections => [ "this:subcollections", ::String, MULTI ]
    }
    super( _key )
  end
  
end
